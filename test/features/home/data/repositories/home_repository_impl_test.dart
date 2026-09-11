import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/features/home/data/datasources/home_data_source.dart';
import 'package:damilva/features/home/data/models/home_remote_entity.dart';
import 'package:damilva/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeDataSource implements HomeDataSourceContract {
  _FakeHomeDataSource({this.response, this.error});

  final HomeRemoteEntity? response;
  final CustomErrors? error;

  @override
  Future<HomeRemoteEntity> getHome() async {
    if (error != null) throw error!;
    return response!;
  }
}

const _json = {
  'carrusel': [
    {
      'imagen': 'img.jpg',
      'antetitulo': 'Otoño / invierno 2026',
      'titular': 'Nueva colección',
      'enlace': '/c/novedades',
    },
  ],
  'novedades': [],
  'categoriasDestacadas': [],
  'config': {'umbralEnvioGratis': 40},
};

void main() {
  test(
    'maps a successful response to a Result.success with domain data',
    () async {
      final repository = HomeRepositoryImpl(
        _FakeHomeDataSource(response: HomeRemoteEntity.fromJson(_json)),
      );

      final result = await repository.getHome();

      expect(result.isSuccess, isTrue);
      expect(result.data!.freeShippingThreshold, 40);
      expect(result.data!.carousel.single.title, 'Nueva colección');
    },
  );

  test('maps a thrown CustomErrors to the matching AppError', () async {
    final repository = HomeRepositoryImpl(
      _FakeHomeDataSource(error: const CustomErrors.noInternetConnection()),
    );

    final result = await repository.getHome();

    expect(result.isFailure, isTrue);
    expect(result.error, const AppError.noInternetConnection());
  });
}
