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

  /// Home
  presentationDi.registerFactory<HomeBloc>(
    () => HomeBloc(presentationDi<GetHomeUseCaseContract>()),
  );
}
