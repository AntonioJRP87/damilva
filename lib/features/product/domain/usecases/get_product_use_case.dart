import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';
import 'package:damilva/features/product/domain/repositories/product_repository.dart';

abstract class GetProductUseCaseContract {
  Future<Result<ProductDetail, AppError>> call(String id);
}

class GetProductUseCase implements GetProductUseCaseContract {
  GetProductUseCase(this._productRepository);

  final ProductRepositoryContract _productRepository;

  @override
  Future<Result<ProductDetail, AppError>> call(String id) {
    return _productRepository.getProduct(id);
  }
}
