import 'package:damilva/features/header/domain/repositories/header_repository.dart';
import 'package:damilva/features/header/domain/usecases/get_categories_use_case.dart';
import 'package:damilva/features/header/domain/usecases/get_search_suggestions_use_case.dart';
import 'package:damilva/features/home/domain/repositories/home_repository.dart';
import 'package:damilva/features/home/domain/usecases/get_home_use_case.dart';
import 'package:get_it/get_it.dart';

final domainDi = GetIt.I;

Future<void> domainInitDi() async {
  /// Header
  domainDi.registerLazySingleton<GetCategoriesUseCaseContract>(
    () => GetCategoriesUseCase(domainDi<HeaderRepositoryContract>()),
  );
  domainDi.registerLazySingleton<GetSearchSuggestionsUseCaseContract>(
    () => GetSearchSuggestionsUseCase(domainDi<HeaderRepositoryContract>()),
  );

  /// Home
  domainDi.registerLazySingleton<GetHomeUseCaseContract>(
    () => GetHomeUseCase(domainDi<HomeRepositoryContract>()),
  );
}
