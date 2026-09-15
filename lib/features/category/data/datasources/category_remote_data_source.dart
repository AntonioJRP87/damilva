import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/core/network/dio_error_resolver.dart';
import 'package:damilva/features/category/data/datasources/category_data_source.dart';
import 'package:damilva/features/category/data/models/category_listing_remote_entity.dart';
import 'package:damilva/features/category/domain/enums/category_sort_option.dart';
import 'package:dio/dio.dart';

class CategoryRemoteDataSource implements CategoryDataSourceContract {
  CategoryRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<CategoryListingRemoteEntity> getCategoryListing({
    required String categoryId,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) {
    return _get(
      '/c/$categoryId',
      _queryParameters(
        size: size,
        color: color,
        maxPrice: maxPrice,
        onlyInStock: onlyInStock,
        sort: sort,
        page: page,
      ),
    );
  }

  @override
  Future<CategoryListingRemoteEntity> getSearchListing({
    required String query,
    String? size,
    String? color,
    double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) {
    return _get('/buscar/resultados', {
      'q': query,
      ..._queryParameters(
        size: size,
        color: color,
        maxPrice: maxPrice,
        onlyInStock: onlyInStock,
        sort: sort,
        page: page,
      ),
    });
  }

  Map<String, dynamic> _queryParameters({
    required String? size,
    required String? color,
    required double? maxPrice,
    required bool onlyInStock,
    required CategorySortOption sort,
    required int page,
  }) {
    return {
      'talla': ?size,
      'color': ?color,
      'precioMax': ?maxPrice,
      'stock': onlyInStock,
      'orden': sort.wireValue,
      'pagina': page,
    };
  }

  Future<CategoryListingRemoteEntity> _get(
    String path,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return CategoryListingRemoteEntity.fromJson(response.data!);
    } on DioException catch (e) {
      throw DioErrorResolver.resolve(e);
    } catch (_) {
      throw const CustomErrors.errorServer();
    }
  }
}
