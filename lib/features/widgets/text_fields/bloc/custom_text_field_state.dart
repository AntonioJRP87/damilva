import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_text_field_state.freezed.dart';

@freezed
abstract class CustomTextFieldState with _$CustomTextFieldState {
  const factory CustomTextFieldState({String? displayedError}) =
      _CustomTextFieldState;
}
