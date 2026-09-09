import 'package:damilva/data/errors/custom/custom_errors.dart';
import 'package:damilva/data/errors/generic/generic_error.dart';

extension ErrorsExtension on Exception {
  GenericError toGenericError() {
    if (this is CustomErrors) {
      return this as CustomErrors;
    }
    return const CustomErrors.unknown();
  }
}
