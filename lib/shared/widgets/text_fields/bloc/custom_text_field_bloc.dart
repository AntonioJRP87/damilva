import 'package:damilva/shared/widgets/text_fields/bloc/custom_text_field_event.dart';
import 'package:damilva/shared/widgets/text_fields/bloc/custom_text_field_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef CustomTextFieldValidator = String? Function(String value);

class CustomTextFieldBloc
    extends Bloc<CustomTextFieldEvent, CustomTextFieldState> {
  CustomTextFieldBloc({this.validator}) : super(const CustomTextFieldState()) {
    on<CustomTextFieldEvent>((event, emit) {
      return switch (event) {
        TextChanged() => _onTextChanged(event, emit),
        FocusLost() => _onFocusLost(event, emit),
      };
    });
  }

  final CustomTextFieldValidator? validator;

  void _onTextChanged(TextChanged event, Emitter<CustomTextFieldState> emit) {
    if (state.displayedError == null) return;
    final error = validator?.call(event.value);
    if (error == null) {
      emit(state.copyWith(displayedError: null));
    }
  }

  void _onFocusLost(FocusLost event, Emitter<CustomTextFieldState> emit) {
    emit(state.copyWith(displayedError: validator?.call(event.value)));
  }
}
