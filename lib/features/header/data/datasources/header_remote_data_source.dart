import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/features/header/data/datasources/header_data_source.dart';
import 'package:damilva/features/header/data/models/category_remote_entity.dart';
import 'package:damilva/features/header/data/models/search_suggestion_remote_entity.dart';
import 'package:dio/dio.dart';

class HeaderRemoteDataSource implements HeaderDataSourceContract {
  HeaderRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<CategoryRemoteEntity>> getCategories() async {
    try {
      final response = await _dio.get<List<dynamic>>('/categorias');
      return response.data!
          .map((e) => CategoryRemoteEntity.fromJson(e as Map<String, dynamic>))
          .toList();
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

  @override
  Future<List<SearchSuggestionRemoteEntity>> getSearchSuggestions(
    String query,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/buscar',
        queryParameters: {'q': query},
      );
      final suggestions = response.data!['sugerencias'] as List;
      return suggestions
          .map(
            (e) => SearchSuggestionRemoteEntity.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
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
