import 'package:damilva/core/errors/custom/custom_errors.dart';

extension CustomErrorsCodeMapper on CustomErrors {
  static CustomErrors? fromCode(String? code) {
    return switch (code) {
      'SYS-01' => const CustomErrors.pageNotFound(),
      _ => null,
    };
  }
}
