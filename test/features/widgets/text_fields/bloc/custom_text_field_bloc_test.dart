import 'package:damilva/features/widgets/text_fields/bloc/custom_text_field_bloc.dart';
import 'package:damilva/features/widgets/text_fields/bloc/custom_text_field_event.dart';
import 'package:damilva/features/widgets/text_fields/bloc/custom_text_field_state.dart';
import 'package:flutter_test/flutter_test.dart';

String? _requiredValidator(String value) =>
    value.isEmpty ? 'Campo obligatorio' : null;

void main() {
  test('does not show an error while typing before the first blur', () async {
    final bloc = CustomTextFieldBloc(validator: _requiredValidator);
    addTearDown(bloc.close);

    bloc.add(const CustomTextFieldEvent.textChanged(''));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.displayedError, isNull);
  });

  test('shows the error after losing focus with an invalid value', () async {
    final bloc = CustomTextFieldBloc(validator: _requiredValidator);
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<CustomTextFieldState>().having(
          (state) => state.displayedError,
          'displayedError',
          'Campo obligatorio',
        ),
      ),
    );

    bloc.add(const CustomTextFieldEvent.focusLost(''));
    await expectation;
  });

  test(
    'clears the error as soon as the value becomes valid, without another blur',
    () async {
      final bloc = CustomTextFieldBloc(validator: _requiredValidator);
      addTearDown(bloc.close);

      bloc.add(const CustomTextFieldEvent.focusLost(''));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.displayedError, isNotNull);

      bloc.add(const CustomTextFieldEvent.textChanged('a'));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.displayedError, isNull);
    },
  );

  test('keeps the error message while the value is still invalid', () async {
    final bloc = CustomTextFieldBloc(validator: _requiredValidator);
    addTearDown(bloc.close);

    bloc.add(const CustomTextFieldEvent.focusLost(''));
    await Future<void>.delayed(Duration.zero);
    final firstError = bloc.state.displayedError;

    bloc.add(const CustomTextFieldEvent.textChanged(''));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.displayedError, firstError);
  });
}
