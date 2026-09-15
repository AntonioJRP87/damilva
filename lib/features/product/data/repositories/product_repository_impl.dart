import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/errors/errors_mapper.dart';
import 'package:damilva/core/errors/generic/generic_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/product/data/datasources/product_data_source.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';
import 'package:damilva/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepositoryContract {
  ProductRepositoryImpl(this._productDataSource);

  final ProductDataSourceContract _productDataSource;

  @override
  Future<Result<ProductDetail, AppError>> getProduct(String id) {
    return _handleError(() async {
      final remote = await _productDataSource.getProduct(id);
      return remote.toDomain();
    });
  }

  @override
  Future<Result<void, AppError>> addToCart({
    required String sku,
    required int quantity,
  }) {
    return _handleError(() {
      return _productDataSource.addToCart(sku: sku, quantity: quantity);
    });
  }

  Future<Result<T, AppError>> _handleError<T>(
    Future<T> Function() action,
  ) async {
    try {
      final data = await action();
      return Result.success(data);
    } on GenericError catch (e) {
      return Result.failure(ErrorsMapper.mapToError(e));
    }
  }
}
