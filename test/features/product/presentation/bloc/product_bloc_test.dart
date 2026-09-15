import 'package:damilva/core/cart/cart_badge_controller.dart';
import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';
import 'package:damilva/features/product/domain/entities/product_variant.dart';
import 'package:damilva/features/product/domain/usecases/add_to_cart_use_case.dart';
import 'package:damilva/features/product/domain/usecases/get_product_use_case.dart';
import 'package:damilva/features/product/presentation/bloc/product_bloc.dart';
import 'package:damilva/features/product/presentation/bloc/product_event.dart';
import 'package:damilva/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGetProductUseCase implements GetProductUseCaseContract {
  _FakeGetProductUseCase(this.result);

  final Result<ProductDetail, AppError> result;

  @override
  Future<Result<ProductDetail, AppError>> call(String id) async => result;
}

class _FakeAddToCartUseCase implements AddToCartUseCaseContract {
  _FakeAddToCartUseCase(this.results);

  final List<Result<void, AppError>> results;
  int calls = 0;
  String? lastSku;
  int? lastQuantity;

  @override
  Future<Result<void, AppError>> call({
    required String sku,
    required int quantity,
  }) async {
    lastSku = sku;
    lastQuantity = quantity;
    final result = results[calls];
    calls++;
    return result;
  }
}

const _redM = ProductVariant(
  color: 'Rojo lunares',
  colorHex: '#B3261E',
  size: 'M',
  sku: 'VMD-ROJ-M',
  stock: 2,
  price: 39.9,
);

const _redL = ProductVariant(
  color: 'Rojo lunares',
  colorHex: '#B3261E',
  size: 'L',
  sku: 'VMD-ROJ-L',
  stock: 0,
  price: 39.9,
);

const _blueM = ProductVariant(
  color: 'Azul liso',
  colorHex: '#1E3A8A',
  size: 'M',
  sku: 'VMD-AZU-M',
  stock: 0,
  price: 39.9,
);

const _product = ProductDetail(
  name: 'Vestido midi de lunares',
  description: 'Vestido midi',
  composition: '100% algodón',
  returnsInfo: 'Devolución gratuita en 30 días',
  price: 39.9,
  previousPrice: 49.9,
  images: ['img1.jpg'],
  variants: [_redM, _redL, _blueM],
  related: [],
);

ProductBloc _buildBloc({
  Result<ProductDetail, AppError>? getProductResult,
  List<Result<void, AppError>>? addToCartResults,
  CartBadgeController? cartBadgeController,
}) {
  return ProductBloc(
    _FakeGetProductUseCase(getProductResult ?? const Result.success(_product)),
    _FakeAddToCartUseCase(addToCartResults ?? const [Result.success(null)]),
    cartBadgeController ?? CartBadgeController(),
  );
}

void main() {
  test('started loads the product and emits success', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);

    bloc.add(const ProductEvent.started('10428'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, ProductStatus.success);
    expect(bloc.state.product, _product);
    expect(bloc.state.selectedColor, isNull);
  });

  test('started with CAT-06 emits unavailable status', () async {
    final bloc = _buildBloc(
      getProductResult: const Result.failure(AppError.productUnavailable()),
    );
    addTearDown(bloc.close);

    bloc.add(const ProductEvent.started('10428'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, ProductStatus.unavailable);
  });

  test('started with a generic failure emits error status', () async {
    final bloc = _buildBloc(
      getProductResult: const Result.failure(AppError.errorServer()),
    );
    addTearDown(bloc.close);

    bloc.add(const ProductEvent.started('10428'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, ProductStatus.error);
    expect(bloc.state.error, const AppError.errorServer());
  });

  test('colorSelected resets the size and quantity', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);
    bloc.add(const ProductEvent.started('10428'));
    await Future<void>.delayed(Duration.zero);

    bloc.add(const ProductEvent.colorSelected('Rojo lunares'));
    bloc.add(const ProductEvent.sizeSelected('M'));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.selectedVariant, _redM);

    bloc.add(const ProductEvent.colorSelected('Azul liso'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.selectedSize, isNull);
    expect(bloc.state.quantity, 1);
  });

  test('quantityIncremented is capped at the variant stock', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);
    bloc.add(const ProductEvent.started('10428'));
    bloc.add(const ProductEvent.colorSelected('Rojo lunares'));
    bloc.add(const ProductEvent.sizeSelected('M'));
    await Future<void>.delayed(Duration.zero);

    bloc.add(const ProductEvent.quantityIncremented());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.quantity, 2);

    bloc.add(const ProductEvent.quantityIncremented());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.quantity, 2); // _redM.stock == 2
  });

  test('quantityDecremented never goes below 1', () async {
    final bloc = _buildBloc();
    addTearDown(bloc.close);
    bloc.add(const ProductEvent.started('10428'));
    bloc.add(const ProductEvent.colorSelected('Rojo lunares'));
    bloc.add(const ProductEvent.sizeSelected('M'));
    await Future<void>.delayed(Duration.zero);

    bloc.add(const ProductEvent.quantityDecremented());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.quantity, 1);
  });

  test(
    'addToCartRequested on success notifies the cart badge controller',
    () async {
      final cartBadgeController = CartBadgeController();
      final notified = <int>[];
      final subscription = cartBadgeController.itemsAdded.listen(notified.add);
      addTearDown(subscription.cancel);

      final bloc = _buildBloc(cartBadgeController: cartBadgeController);
      addTearDown(bloc.close);
      bloc.add(const ProductEvent.started('10428'));
      bloc.add(const ProductEvent.colorSelected('Rojo lunares'));
      bloc.add(const ProductEvent.sizeSelected('M'));
      await Future<void>.delayed(Duration.zero);

      bloc.add(const ProductEvent.addToCartRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.addToCartStatus, AddToCartStatus.success);
      expect(notified, [1]);
    },
  );

  test(
    'addToCartRequested with CAR-04 clamps the quantity to the known stock',
    () async {
      final bloc = _buildBloc(
        addToCartResults: const [Result.failure(AppError.insufficientStock())],
      );
      addTearDown(bloc.close);
      bloc.add(const ProductEvent.started('10428'));
      bloc.add(const ProductEvent.colorSelected('Rojo lunares'));
      bloc.add(const ProductEvent.sizeSelected('M'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const ProductEvent.quantityIncremented());
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.quantity, 2);

      bloc.add(const ProductEvent.addToCartRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.addToCartStatus, AddToCartStatus.insufficientStock);
      expect(bloc.state.quantity, _redM.stock);
    },
  );

  test(
    'addToCartRequested with a generic failure keeps the cart untouched',
    () async {
      final cartBadgeController = CartBadgeController();
      final notified = <int>[];
      final subscription = cartBadgeController.itemsAdded.listen(notified.add);
      addTearDown(subscription.cancel);

      final bloc = _buildBloc(
        addToCartResults: const [Result.failure(AppError.errorServer())],
        cartBadgeController: cartBadgeController,
      );
      addTearDown(bloc.close);
      bloc.add(const ProductEvent.started('10428'));
      bloc.add(const ProductEvent.colorSelected('Rojo lunares'));
      bloc.add(const ProductEvent.sizeSelected('M'));
      await Future<void>.delayed(Duration.zero);

      bloc.add(const ProductEvent.addToCartRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.addToCartStatus, AddToCartStatus.error);
      expect(notified, isEmpty);
    },
  );
}
