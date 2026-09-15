import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/errors/app_error.dart';
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
      ProductUnavailable() => localizations.product_unavailable_title,
      InsufficientStock() => localizations.product_quantity_adjusted,
      DuplicateReferenceOrSKU() => localizations.duplicate_reference_or_SKU,
      RepeatedVariant() => localizations.repeated_variant,
      ProductWithoutVariantsOrImage() =>
        localizations.product_without_variants_or_image,
      ImageTooLargeOrUnsupported() =>
        localizations.image_too_large_or_unsupported,
      NoInternetConnection() => localizations.no_internet_connection,
      ErrorServer() => localizations.error_server,
      PageNotFound() => localizations.page_not_found,
    };
  }

  String? errorDetail(BuildContext context, AppError error) {
    final localizations = context.localizations;

    return switch (error) {
      InvalidCredentials() => localizations.info_invalid_credentials,
      SessionExpired() => localizations.info_session_expired,
      TooManyLoginAttempts() => localizations.info_too_many_login_attempts,
      NoInternetConnection() => localizations.info_no_internet_connection,
      ErrorServer() => localizations.info_error_server,
      PageNotFound() => localizations.info_page_not_found,
      Unknown() ||
      EmailInUse() ||
      WeakPassword() ||
      RequiredField() ||
      ProductUnavailable() ||
      InsufficientStock() ||
      DuplicateReferenceOrSKU() ||
      RepeatedVariant() ||
      ProductWithoutVariantsOrImage() ||
      ImageTooLargeOrUnsupported() => null,
    };
  }
}
