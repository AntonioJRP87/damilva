import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_text_field_event.freezed.dart';

@freezed
sealed class CustomTextFieldEvent with _$CustomTextFieldEvent {
  const factory CustomTextFieldEvent.textChanged(String value) = TextChanged;
  const factory CustomTextFieldEvent.focusLost(String value) = FocusLost;
}
