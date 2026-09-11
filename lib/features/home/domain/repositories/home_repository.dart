import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/home/domain/entities/home_content.dart';

abstract class HomeRepositoryContract {
  Future<Result<HomeContent, AppError>> getHome();
}
