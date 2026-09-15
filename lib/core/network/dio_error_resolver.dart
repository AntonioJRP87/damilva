import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/core/errors/custom/custom_errors_code_mapper.dart';
import 'package:dio/dio.dart';

/// Turns a [DioException] into the specific [CustomErrors] the backend
/// reported, instead of every failure collapsing into the same generic
/// server error. The backend identifies the failure with a `codigo` field
/// (one of the codes from the signed message catalog, e.g. `{"codigo":
/// "SYS-01"}`) in the response body; an unrecognized or missing code falls
/// back to [CustomErrors.errorServer].
class DioErrorResolver {
  const DioErrorResolver._();

  static CustomErrors resolve(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const CustomErrors.noInternetConnection();
      default:
        final data = exception.response?.data;
        final code = data is Map ? data['codigo'] as String? : null;
        return CustomErrorsCodeMapper.fromCode(code) ??
            const CustomErrors.errorServer();
    }
  }
}
