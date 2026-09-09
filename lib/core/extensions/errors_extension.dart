import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/core/errors/generic/generic_error.dart';

extension ErrorsExtension on Exception {
  GenericError toGenericError() {
    if (this is CustomErrors) {
      return this as CustomErrors;
    }
    return const CustomErrors.unknown();
  }
}
