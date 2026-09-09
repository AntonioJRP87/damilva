import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
sealed class AppError with _$AppError {
  // Unknown
  const factory AppError.unknown() = Unknown;

  // Access and account
  const factory AppError.invalidCredentials() = InvalidCredentials;
  const factory AppError.emailInUse() = EmailInUse;
  const factory AppError.weakPassword() = WeakPassword;
  const factory AppError.sessionExpired() = SessionExpired;
  const factory AppError.tooManyLoginAttempts() = TooManyLoginAttempts;

  // Checkout
  const factory AppError.requiredField() = RequiredField;

  // Administration panel
  const factory AppError.duplicateReferenceOrSKU() = DuplicateReferenceOrSKU;
  const factory AppError.repeatedVariant() = RepeatedVariant;
  const factory AppError.productWithoutVariantsOrImage() =
      ProductWithoutVariantsOrImage;
  const factory AppError.imageTooLargeOrUnsupported() =
      ImageTooLargeOrUnsupported;

  // Transverse
  const factory AppError.noInternetConnection() = NoInternetConnection;
  const factory AppError.errorServer() = ErrorServer;
}
