import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';
import 'package:damilva/features/product/domain/entities/product_variant.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_state.freezed.dart';

enum ProductStatus { initial, loading, success, unavailable, error }

enum AddToCartStatus { idle, submitting, success, insufficientStock, error }

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    @Default(ProductStatus.initial) ProductStatus status,
    ProductDetail? product,
    AppError? error,
    String? selectedColor,
    String? selectedSize,
    @Default(1) int quantity,
    @Default(AddToCartStatus.idle) AddToCartStatus addToCartStatus,
    AppError? addToCartError,
    @Default(0) int addToCartRequestId,
  }) = _ProductState;

  const ProductState._();

  ProductVariant? get selectedVariant {
    final product = this.product;
    final color = selectedColor;
    final size = selectedSize;
    if (product == null || color == null || size == null) return null;
    return product.variantFor(color: color, size: size);
  }

  bool get selectedColorSoldOut {
    final product = this.product;
    final color = selectedColor;
    if (product == null || color == null) return false;
    return product.variantsForColor(color).every((v) => v.soldOut);
  }
}
