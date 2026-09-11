import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/home/domain/entities/home_content.dart';
import 'package:damilva/features/home/domain/repositories/home_repository.dart';

abstract class GetHomeUseCaseContract {
  Future<Result<HomeContent, AppError>> call();
}

class GetHomeUseCase implements GetHomeUseCaseContract {
  GetHomeUseCase(this._homeRepository);

  final HomeRepositoryContract _homeRepository;

  @override
  Future<Result<HomeContent, AppError>> call() {
    return _homeRepository.getHome();
  }
}
