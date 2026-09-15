import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/core/network/dio_error_resolver.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _exception({
  required DioExceptionType type,
  Object? responseData,
  int? statusCode,
}) {
  final requestOptions = RequestOptions(path: '/c/novedades');
  return DioException(
    requestOptions: requestOptions,
    type: type,
    response: responseData == null
        ? null
        : Response(
            requestOptions: requestOptions,
            data: responseData,
            statusCode: statusCode,
          ),
  );
}

void main() {
  test('connection errors resolve to noInternetConnection', () {
    for (final type in [
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    ]) {
      final result = DioErrorResolver.resolve(_exception(type: type));
      expect(result, const CustomErrors.noInternetConnection());
    }
  });

  test('a recognized "codigo" in the response maps to its specific error', () {
    final result = DioErrorResolver.resolve(
      _exception(
        type: DioExceptionType.badResponse,
        responseData: {'codigo': 'SYS-01'},
        statusCode: 404,
      ),
    );

    expect(result, const CustomErrors.pageNotFound());
  });

  test('an unrecognized "codigo" falls back to errorServer', () {
    final result = DioErrorResolver.resolve(
      _exception(
        type: DioExceptionType.badResponse,
        responseData: {'codigo': 'NOT-A-REAL-CODE'},
        statusCode: 500,
      ),
    );

    expect(result, const CustomErrors.errorServer());
  });

  test('a response without a "codigo" falls back to errorServer', () {
    final result = DioErrorResolver.resolve(
      _exception(
        type: DioExceptionType.badResponse,
        responseData: {'mensaje': 'algo salió mal'},
        statusCode: 500,
      ),
    );

    expect(result, const CustomErrors.errorServer());
  });

  test('no response body at all falls back to errorServer', () {
    final result = DioErrorResolver.resolve(
      _exception(type: DioExceptionType.unknown),
    );

    expect(result, const CustomErrors.errorServer());
  });
}
