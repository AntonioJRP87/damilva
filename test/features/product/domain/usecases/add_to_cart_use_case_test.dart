import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';
import 'package:damilva/features/product/domain/repositories/product_repository.dart';
import 'package:damilva/features/product/domain/usecases/add_to_cart_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProductRepository implements ProductRepositoryContract {
  _FakeProductRepository(this.result);

  final Result<void, AppError> result;
  String? lastSku;
  int? lastQuantity;

  @override
  Future<Result<ProductDetail, AppError>> getProduct(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void, AppError>> addToCart({
    required String sku,
    required int quantity,
  }) async {
    lastSku = sku;
    lastQuantity = quantity;
    return result;
  }
}

void main() {
  test('delegates to the repository with the given sku and quantity', () async {
    final repository = _FakeProductRepository(const Result.success(null));
    final useCase = AddToCartUseCase(repository);

    final result = await useCase(sku: 'VMD-ROJ-M', quantity: 2);

    expect(result.isSuccess, isTrue);
    expect(repository.lastSku, 'VMD-ROJ-M');
    expect(repository.lastQuantity, 2);
  });

  test('returns the error from the repository on failure', () async {
    final useCase = AddToCartUseCase(
      _FakeProductRepository(
        const Result.failure(AppError.insufficientStock()),
      ),
    );

    final result = await useCase(sku: 'VMD-ROJ-M', quantity: 2);

    expect(result.isFailure, isTrue);
    expect(result.error, const AppError.insufficientStock());
  });
}
