import 'package:damilva/features/home/domain/repositories/home_repository.dart';
import 'package:damilva/features/home/domain/usecases/get_home_use_case.dart';
import 'package:get_it/get_it.dart';

final domainDi = GetIt.I;

Future<void> domainInitDi() async {
  /// Home
  domainDi.registerLazySingleton<GetHomeUseCaseContract>(
    () => GetHomeUseCase(domainDi<HomeRepositoryContract>()),
  );
}
