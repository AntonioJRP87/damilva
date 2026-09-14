import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/header/domain/entities/category.dart';
import 'package:damilva/features/header/domain/repositories/header_repository.dart';

abstract class GetCategoriesUseCaseContract {
  Future<Result<List<Category>, AppError>> call();
}

class GetCategoriesUseCase implements GetCategoriesUseCaseContract {
  GetCategoriesUseCase(this._headerRepository);

  final HeaderRepositoryContract _headerRepository;

  @override
  Future<Result<List<Category>, AppError>> call() {
    return _headerRepository.getCategories();
  }
}
