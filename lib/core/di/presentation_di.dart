import 'package:damilva/features/widgets/text_fields/bloc/custom_text_field_bloc.dart';
import 'package:get_it/get_it.dart';

final presentationDi = GetIt.I;

Future<void> presentationInitDi() async {
  /// Shared widgets
  presentationDi.registerFactoryParam<
    CustomTextFieldBloc,
    CustomTextFieldValidator?,
    void
  >((validator, _) => CustomTextFieldBloc(validator: validator));
}
