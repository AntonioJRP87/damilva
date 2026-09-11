import 'package:dio/dio.dart';

class DioClient {
  const DioClient._();

  static const String _defaultBaseUrl =
      'https://darkroom-flagman-stiffly.ngrok-free.dev';

  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: _defaultBaseUrl,
        ),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {'ngrok-skip-browser-warning': 'true'},
      ),
    );
  }
}
