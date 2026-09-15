import 'package:damilva/features/category/domain/usecases/get_category_listing_use_case.dart';
import 'package:damilva/features/category/domain/usecases/get_search_listing_use_case.dart';
import 'package:damilva/features/category/presentation/bloc/category_list_bloc.dart';
import 'package:damilva/features/header/domain/usecases/get_categories_use_case.dart';
import 'package:damilva/features/header/domain/usecases/get_search_suggestions_use_case.dart';
import 'package:damilva/features/header/presentation/bloc/header_bloc.dart';
import 'package:damilva/features/home/domain/usecases/get_home_use_case.dart';
import 'package:damilva/features/home/presentation/bloc/home_bloc.dart';
import 'package:damilva/shared/widgets/text_fields/bloc/custom_text_field_bloc.dart';
import 'package:get_it/get_it.dart';

final presentationDi = GetIt.I;

Future<void> presentationInitDi() async {
  /// Shared widgets
  presentationDi.registerFactoryParam<
    CustomTextFieldBloc,
    CustomTextFieldValidator?,
    void
  >((validator, _) => CustomTextFieldBloc(validator: validator));

  /// Category
  presentationDi.registerFactory<CategoryListBloc>(
    () => CategoryListBloc(
      presentationDi<GetCategoryListingUseCaseContract>(),
      presentationDi<GetSearchListingUseCaseContract>(),
    ),
  );

  /// Header
  presentationDi.registerLazySingleton<HeaderBloc>(
    () => HeaderBloc(
      presentationDi<GetCategoriesUseCaseContract>(),
      presentationDi<GetSearchSuggestionsUseCaseContract>(),
    ),
  );

  /// Home
  presentationDi.registerFactory<HomeBloc>(
    () => HomeBloc(presentationDi<GetHomeUseCaseContract>()),
  );
}
