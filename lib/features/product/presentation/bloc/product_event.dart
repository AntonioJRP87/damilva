import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_event.freezed.dart';

@freezed
sealed class ProductEvent with _$ProductEvent {
  const factory ProductEvent.started(String id) = ProductStarted;

  const factory ProductEvent.retried() = ProductRetried;

  const factory ProductEvent.colorSelected(String color) = ProductColorSelected;

  const factory ProductEvent.sizeSelected(String size) = ProductSizeSelected;

  const factory ProductEvent.quantityIncremented() = ProductQuantityIncremented;

  const factory ProductEvent.quantityDecremented() = ProductQuantityDecremented;

  const factory ProductEvent.addToCartRequested() = ProductAddToCartRequested;
}
