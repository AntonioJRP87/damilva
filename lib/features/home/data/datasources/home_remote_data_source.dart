import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/features/home/data/datasources/home_data_source.dart';
import 'package:damilva/features/home/data/models/home_remote_entity.dart';
import 'package:dio/dio.dart';

class HomeRemoteDataSource implements HomeDataSourceContract {
  HomeRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<HomeRemoteEntity> getHome() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/home');
      return HomeRemoteEntity.fromJson(response.data!);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw const CustomErrors.noInternetConnection();
        default:
          throw const CustomErrors.errorServer();
      }
    } catch (_) {
      throw const CustomErrors.errorServer();
    }
  }
}
