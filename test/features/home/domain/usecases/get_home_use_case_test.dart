import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/home/domain/entities/home_content.dart';
import 'package:damilva/features/home/domain/repositories/home_repository.dart';
import 'package:damilva/features/home/domain/usecases/get_home_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeRepository implements HomeRepositoryContract {
  _FakeHomeRepository(this.result);

  final Result<HomeContent, AppError> result;

  @override
  Future<Result<HomeContent, AppError>> getHome() async => result;
}

const _content = HomeContent(
  carousel: [],
  newArrivals: [],
  featuredCategories: [],
  freeShippingThreshold: 40,
);

void main() {
  test('returns the content from the repository on success', () async {
    final useCase = GetHomeUseCase(
      _FakeHomeRepository(const Result.success(_content)),
    );

    final result = await useCase();

    expect(result.isSuccess, isTrue);
    expect(result.data, _content);
  });

  test('returns the error from the repository on failure', () async {
    final useCase = GetHomeUseCase(
      _FakeHomeRepository(const Result.failure(AppError.errorServer())),
    );

    final result = await useCase();

    expect(result.isFailure, isTrue);
    expect(result.error, const AppError.errorServer());
  });
}
