import 'package:damilva/domain/models/app_error.dart';
import 'package:damilva/presentation/extensions/context_extension.dart';
import 'package:flutter/material.dart';

mixin ErrorsMessageMixin {
  String errorText(BuildContext context, AppError error) {
    final localizations = context.localizations;

    return switch (error) {
      Unknown() => localizations.unknown,
      InvalidCredentials() => localizations.invalid_credentials,
      EmailInUse() => localizations.email_in_use,
      WeakPassword() => localizations.weak_password,
      SessionExpired() => localizations.session_expired,
      TooManyLoginAttempts() => localizations.too_many_login_attempts,
      RequiredField() => localizations.required_field,
      DuplicateReferenceOrSKU() => localizations.duplicate_reference_or_SKU,
      RepeatedVariant() => localizations.repeated_variant,
      ProductWithoutVariantsOrImage() =>
        localizations.product_without_variants_or_image,
      ImageTooLargeOrUnsupported() =>
        localizations.image_too_large_or_unsupported,
      NoInternetConnection() => localizations.no_internet_connection,
      ErrorServer() => localizations.error_server,
    };
  }
}
