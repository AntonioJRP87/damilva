import 'package:damilva/core/errors/custom/custom_errors.dart';
import 'package:damilva/core/errors/generic/generic_error.dart';
import 'package:damilva/core/errors/app_error.dart';

class ErrorsMapper {
  static AppError mapToError(GenericError error) {
    if (error is CustomErrors) {
      return error.when(
        unknown: () => const AppError.unknown(),
        invalidCredentials: () => const AppError.invalidCredentials(),
        emailInUse: () => const AppError.emailInUse(),
        weakPassword: () => const AppError.weakPassword(),
        sessionExpired: () => const AppError.sessionExpired(),
        tooManyLoginAttempts: () => const AppError.tooManyLoginAttempts(),
        requiredField: () => const AppError.requiredField(),
        duplicateReferenceOrSKU: () => const AppError.duplicateReferenceOrSKU(),
        repeatedVariant: () => const AppError.repeatedVariant(),
        productWithoutVariantsOrImage: () =>
            const AppError.productWithoutVariantsOrImage(),
        imageTooLargeOrUnsupported: () =>
            const AppError.imageTooLargeOrUnsupported(),
        noInternetConnection: () => const AppError.noInternetConnection(),
        errorServer: () => const AppError.errorServer(),
      );
    }
    return const AppError.unknown();
  }
}
