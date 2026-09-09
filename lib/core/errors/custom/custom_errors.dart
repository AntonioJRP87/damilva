import 'package:damilva/core/errors/generic/generic_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_errors.freezed.dart';

@freezed
class CustomErrors with _$CustomErrors implements GenericError, Exception {
  // Unknown
  const factory CustomErrors.unknown() = Unknown;

  // Access and account
  const factory CustomErrors.invalidCredentials() = InvalidCredentials;
  const factory CustomErrors.emailInUse() = EmailInUse;
  const factory CustomErrors.weakPassword() = WeakPassword;
  const factory CustomErrors.sessionExpired() = SessionExpired;
  const factory CustomErrors.tooManyLoginAttempts() = TooManyLoginAttempts;

  // Checkout
  const factory CustomErrors.requiredField() = RequiredField;

  // Administration panel
  const factory CustomErrors.duplicateReferenceOrSKU() =
      DuplicateReferenceOrSKU;
  const factory CustomErrors.repeatedVariant() = RepeatedVariant;
  const factory CustomErrors.productWithoutVariantsOrImage() =
      ProductWithoutVariantsOrImage;
  const factory CustomErrors.imageTooLargeOrUnsupported() =
      ImageTooLargeOrUnsupported;

  // Transverse
  const factory CustomErrors.noInternetConnection() = NoInternetConnection;
  const factory CustomErrors.errorServer() = ErrorServer;
}
