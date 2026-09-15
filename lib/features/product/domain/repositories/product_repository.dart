import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';

abstract class ProductRepositoryContract {
  Future<Result<ProductDetail, AppError>> getProduct(String id);

  Future<Result<void, AppError>> addToCart({
    required String sku,
    required int quantity,
  });
}
