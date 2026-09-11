import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/errors/errors_mapper.dart';
import 'package:damilva/core/errors/generic/generic_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/home/data/datasources/home_data_source.dart';
import 'package:damilva/features/home/domain/entities/home_content.dart';
import 'package:damilva/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepositoryContract {
  HomeRepositoryImpl(this._homeDataSource);

  final HomeDataSourceContract _homeDataSource;

  @override
  Future<Result<HomeContent, AppError>> getHome() {
    return _handleError(() async {
      final remote = await _homeDataSource.getHome();
      return remote.toDomain();
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
