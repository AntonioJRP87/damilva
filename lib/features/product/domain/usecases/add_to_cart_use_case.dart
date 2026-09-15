import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/product/domain/repositories/product_repository.dart';

abstract class AddToCartUseCaseContract {
  Future<Result<void, AppError>> call({
    required String sku,
    required int quantity,
  });
}

class AddToCartUseCase implements AddToCartUseCaseContract {
  AddToCartUseCase(this._productRepository);

  final ProductRepositoryContract _productRepository;

  @override
  Future<Result<void, AppError>> call({
    required String sku,
    required int quantity,
  }) {
    return _productRepository.addToCart(sku: sku, quantity: quantity);
  }
}
