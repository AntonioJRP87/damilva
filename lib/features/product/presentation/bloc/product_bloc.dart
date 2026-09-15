import 'package:damilva/core/cart/cart_badge_controller.dart';
import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/features/product/domain/usecases/add_to_cart_use_case.dart';
import 'package:damilva/features/product/domain/usecases/get_product_use_case.dart';
import 'package:damilva/features/product/presentation/bloc/product_event.dart';
import 'package:damilva/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(
    this._getProductUseCase,
    this._addToCartUseCase,
    this._cartBadgeController,
  ) : super(const ProductState()) {
    on<ProductEvent>((event, emit) {
      return switch (event) {
        ProductStarted() => _onStarted(event, emit),
        ProductRetried() => _onRetried(emit),
        ProductColorSelected() => _onColorSelected(event, emit),
        ProductSizeSelected() => _onSizeSelected(event, emit),
        ProductQuantityIncremented() => _onQuantityIncremented(emit),
        ProductQuantityDecremented() => _onQuantityDecremented(emit),
        ProductAddToCartRequested() => _onAddToCartRequested(emit),
      };
    });
  }

  final GetProductUseCaseContract _getProductUseCase;
  final AddToCartUseCaseContract _addToCartUseCase;
  final CartBadgeController _cartBadgeController;

  String? _productId;

  Future<void> _onStarted(
    ProductStarted event,
    Emitter<ProductState> emit,
  ) async {
    _productId = event.id;
    emit(const ProductState(status: ProductStatus.loading));
    await _fetch(emit);
  }

  Future<void> _onRetried(Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading, error: null));
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<ProductState> emit) async {
    final result = await _getProductUseCase(_productId!);

    if (result.isFailure) {
      final error = result.error!;
      emit(
        state.copyWith(
          status: error is ProductUnavailable
              ? ProductStatus.unavailable
              : ProductStatus.error,
          error: error,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ProductStatus.success,
        product: result.data,
        selectedColor: null,
        selectedSize: null,
        quantity: 1,
      ),
    );
  }

  void _onColorSelected(
    ProductColorSelected event,
    Emitter<ProductState> emit,
  ) {
    emit(
      state.copyWith(
        selectedColor: event.color,
        selectedSize: null,
        quantity: 1,
      ),
    );
  }

  void _onSizeSelected(ProductSizeSelected event, Emitter<ProductState> emit) {
    emit(state.copyWith(selectedSize: event.size, quantity: 1));
  }

  void _onQuantityIncremented(Emitter<ProductState> emit) {
    final stock = state.selectedVariant?.stock;
    if (stock == null || state.quantity >= stock) return;
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void _onQuantityDecremented(Emitter<ProductState> emit) {
    if (state.quantity <= 1) return;
    emit(state.copyWith(quantity: state.quantity - 1));
  }

  Future<void> _onAddToCartRequested(Emitter<ProductState> emit) async {
    final variant = state.selectedVariant;
    if (variant == null ||
        state.addToCartStatus == AddToCartStatus.submitting) {
      return;
    }

    emit(
      state.copyWith(
        addToCartStatus: AddToCartStatus.submitting,
        addToCartError: null,
      ),
    );

    final result = await _addToCartUseCase(
      sku: variant.sku,
      quantity: state.quantity,
    );

    if (result.isSuccess) {
      _cartBadgeController.notifyItemsAdded(state.quantity);
      emit(
        state.copyWith(
          addToCartStatus: AddToCartStatus.success,
          addToCartRequestId: state.addToCartRequestId + 1,
        ),
      );
      return;
    }

    final error = result.error!;
    if (error is InsufficientStock) {
      emit(
        state.copyWith(
          addToCartStatus: AddToCartStatus.insufficientStock,
          addToCartError: error,
          quantity: variant.stock > 0 ? variant.stock : 1,
          addToCartRequestId: state.addToCartRequestId + 1,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        addToCartStatus: AddToCartStatus.error,
        addToCartError: error,
        addToCartRequestId: state.addToCartRequestId + 1,
      ),
    );
  }
}
