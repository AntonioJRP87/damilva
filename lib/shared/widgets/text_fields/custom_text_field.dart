import 'package:damilva/core/di/presentation_di.dart';
import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:damilva/shared/widgets/text_fields/bloc/custom_text_field_bloc.dart';
import 'package:damilva/shared/widgets/text_fields/bloc/custom_text_field_event.dart';
import 'package:damilva/shared/widgets/text_fields/bloc/custom_text_field_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final CustomTextFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final CustomTextFieldBloc _bloc = presentationDi<CustomTextFieldBloc>(
    param1: widget.validator,
  );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _bloc.add(CustomTextFieldEvent.focusLost(_controller.text));
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<CustomTextFieldBloc, CustomTextFieldState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: typography.text12w400.copyWith(color: colors.ink),
              ),
              const SizedBox(height: AppSizes.textFieldLabelSpacing),
              SizedBox(
                height: AppSizes.textFieldHeight,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  style: typography.text14w400.copyWith(color: colors.ink),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    errorText: state.displayedError,
                  ),
                  onChanged: (value) {
                    _bloc.add(CustomTextFieldEvent.textChanged(value));
                    widget.onChanged?.call(value);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
