import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/product/domain/entities/product_detail.dart';
import 'package:damilva/features/product/domain/repositories/product_repository.dart';
import 'package:damilva/features/product/domain/usecases/get_product_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProductRepository implements ProductRepositoryContract {
  _FakeProductRepository(this.result);

  final Result<ProductDetail, AppError> result;
  String? lastId;

  @override
  Future<Result<ProductDetail, AppError>> getProduct(String id) async {
    lastId = id;
    return result;
  }

  @override
  Future<Result<void, AppError>> addToCart({
    required String sku,
    required int quantity,
  }) {
    throw UnimplementedError();
  }
}

const _product = ProductDetail(
  name: 'Vestido midi de lunares',
  description: 'Vestido midi',
  composition: '100% algodón',
  returnsInfo: 'Devolución gratuita en 30 días',
  price: 39.9,
  images: ['img1.jpg'],
  variants: [],
  related: [],
);

void main() {
  test('delegates to the repository with the given id', () async {
    final repository = _FakeProductRepository(const Result.success(_product));
    final useCase = GetProductUseCase(repository);

    final result = await useCase('10428');

    expect(result.isSuccess, isTrue);
    expect(repository.lastId, '10428');
  });

  test('returns the error from the repository on failure', () async {
    final useCase = GetProductUseCase(
      _FakeProductRepository(
        const Result.failure(AppError.productUnavailable()),
      ),
    );

    final result = await useCase('10428');

    expect(result.isFailure, isTrue);
    expect(result.error, const AppError.productUnavailable());
  });
}
