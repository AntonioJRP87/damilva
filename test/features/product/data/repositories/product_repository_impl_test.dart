import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/features/product/data/datasources/product_data_source.dart';
import 'package:damilva/features/product/data/models/product_detail_remote_entity.dart';
import 'package:damilva/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProductDataSource implements ProductDataSourceContract {
  _FakeProductDataSource({this.response, this.error});

  final ProductDetailRemoteEntity? response;
  final CustomErrors? error;

  @override
  Future<ProductDetailRemoteEntity> getProduct(String id) async {
    if (error != null) throw error!;
    return response!;
  }

  @override
  Future<void> addToCart({required String sku, required int quantity}) async {
    if (error != null) throw error!;
  }
}

const _json = {
  'nombre': 'Vestido midi de lunares',
  'descripcion': 'Vestido midi',
  'composicion': '100% algodón',
  'devoluciones': 'Devolución gratuita en 30 días',
  'precio': 39.9,
  'precioAnterior': 49.9,
  'imagenes': ['img1.jpg'],
  'variantes': [
    {
      'color': 'Rojo lunares',
      'colorHex': '#B3261E',
      'talla': 'M',
      'sku': 'VMD-ROJ-M',
      'stock': 5,
      'precio': 39.9,
    },
  ],
  'relacionados': [
    {
      'id': '2',
      'nombre': 'Vestido corto liso',
      'precio': 29.9,
      'imagen': 'img2.jpg',
    },
  ],
};

void main() {
  test('maps a successful product response to a Result.success', () async {
    final repository = ProductRepositoryImpl(
      _FakeProductDataSource(
        response: ProductDetailRemoteEntity.fromJson(_json),
      ),
    );

    final result = await repository.getProduct('10428');

    expect(result.isSuccess, isTrue);
    expect(result.data!.name, 'Vestido midi de lunares');
    expect(result.data!.variants.single.sku, 'VMD-ROJ-M');
    expect(result.data!.related.single.name, 'Vestido corto liso');
  });

  test('maps a thrown CAT-06 to productUnavailable', () async {
    final repository = ProductRepositoryImpl(
      _FakeProductDataSource(error: const CustomErrors.productUnavailable()),
    );

    final result = await repository.getProduct('10428');

    expect(result.isFailure, isTrue);
    expect(result.error, const AppError.productUnavailable());
  });

  test('maps a thrown CAR-04 to insufficientStock on addToCart', () async {
    final repository = ProductRepositoryImpl(
      _FakeProductDataSource(error: const CustomErrors.insufficientStock()),
    );

    final result = await repository.addToCart(sku: 'VMD-ROJ-M', quantity: 5);

    expect(result.isFailure, isTrue);
    expect(result.error, const AppError.insufficientStock());
  });
}
