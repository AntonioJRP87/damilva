import 'package:damilva/core/network/dio_client.dart';
import 'package:damilva/features/home/data/datasources/home_data_source.dart';
import 'package:damilva/features/home/data/datasources/home_remote_data_source.dart';
import 'package:damilva/features/home/data/repositories/home_repository_impl.dart';
import 'package:damilva/features/home/domain/repositories/home_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final dataDi = GetIt.I;

Future<void> dataInitDi() async {
  /// Core
  dataDi.registerLazySingleton<Dio>(DioClient.create);

  /// Home
  dataDi.registerLazySingleton<HomeDataSourceContract>(
    () => HomeRemoteDataSource(dataDi<Dio>()),
  );
  dataDi.registerLazySingleton<HomeRepositoryContract>(
    () => HomeRepositoryImpl(dataDi<HomeDataSourceContract>()),
  );
}
