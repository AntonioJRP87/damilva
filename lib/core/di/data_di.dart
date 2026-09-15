import 'package:damilva/core/network/dio_client.dart';
import 'package:damilva/features/category/data/datasources/category_data_source.dart';
import 'package:damilva/features/category/data/datasources/category_remote_data_source.dart';
import 'package:damilva/features/category/data/repositories/category_repository_impl.dart';
import 'package:damilva/features/category/domain/repositories/category_repository.dart';
import 'package:damilva/features/header/data/datasources/header_data_source.dart';
import 'package:damilva/features/header/data/datasources/header_remote_data_source.dart';
import 'package:damilva/features/header/data/repositories/header_repository_impl.dart';
import 'package:damilva/features/header/domain/repositories/header_repository.dart';
import 'package:damilva/features/home/data/datasources/home_data_source.dart';
import 'package:damilva/features/home/data/datasources/home_remote_data_source.dart';
import 'package:damilva/features/home/data/repositories/home_repository_impl.dart';
import 'package:damilva/features/home/domain/repositories/home_repository.dart';
import 'package:damilva/features/product/data/datasources/product_data_source.dart';
import 'package:damilva/features/product/data/datasources/product_remote_data_source.dart';
import 'package:damilva/features/product/data/repositories/product_repository_impl.dart';
import 'package:damilva/features/product/domain/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final dataDi = GetIt.I;

Future<void> dataInitDi() async {
  /// Core
  dataDi.registerLazySingleton<Dio>(DioClient.create);

  /// Category
  dataDi.registerLazySingleton<CategoryDataSourceContract>(
    () => CategoryRemoteDataSource(dataDi<Dio>()),
  );
  dataDi.registerLazySingleton<CategoryRepositoryContract>(
    () => CategoryRepositoryImpl(dataDi<CategoryDataSourceContract>()),
  );

  /// Header
  dataDi.registerLazySingleton<HeaderDataSourceContract>(
    () => HeaderRemoteDataSource(dataDi<Dio>()),
  );
  dataDi.registerLazySingleton<HeaderRepositoryContract>(
    () => HeaderRepositoryImpl(dataDi<HeaderDataSourceContract>()),
  );

  /// Home
  dataDi.registerLazySingleton<HomeDataSourceContract>(
    () => HomeRemoteDataSource(dataDi<Dio>()),
  );
  dataDi.registerLazySingleton<HomeRepositoryContract>(
    () => HomeRepositoryImpl(dataDi<HomeDataSourceContract>()),
  );

  /// Product
  dataDi.registerLazySingleton<ProductDataSourceContract>(
    () => ProductRemoteDataSource(dataDi<Dio>()),
  );
  dataDi.registerLazySingleton<ProductRepositoryContract>(
    () => ProductRepositoryImpl(dataDi<ProductDataSourceContract>()),
  );
}
