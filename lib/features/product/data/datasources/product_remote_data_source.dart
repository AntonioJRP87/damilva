import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/core/network/dio_error_resolver.dart';
import 'package:damilva/features/product/data/datasources/product_data_source.dart';
import 'package:damilva/features/product/data/models/product_detail_remote_entity.dart';
import 'package:dio/dio.dart';

class ProductRemoteDataSource implements ProductDataSourceContract {
  ProductRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<ProductDetailRemoteEntity> getProduct(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/p/$id');
      return ProductDetailRemoteEntity.fromJson(response.data!);
    } on DioException catch (e) {
      throw DioErrorResolver.resolve(e);
    } catch (_) {
      throw const CustomErrors.errorServer();
    }
  }

  @override
  Future<void> addToCart({required String sku, required int quantity}) async {
    try {
      await _dio.post<void>(
        '/carrito',
        data: {'sku': sku, 'cantidad': quantity},
      );
    } on DioException catch (e) {
      throw DioErrorResolver.resolve(e);
    } catch (_) {
      throw const CustomErrors.errorServer();
    }
  }
}
