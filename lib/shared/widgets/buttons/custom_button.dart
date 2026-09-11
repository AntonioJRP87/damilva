import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

enum CustomButtonVariant { primary, secondary, ghost }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.loadingLabel,
    this.fullWidth,
  }) : assert(
         !isLoading || loadingLabel != null,
         'loadingLabel is required when isLoading is true',
       );

  final String label;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final String? loadingLabel;
  final bool? fullWidth;

  bool get _isDisabled => onPressed == null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final baseStyle = context.damilvaTypography.text14w800;

    final backgroundColor = switch (variant) {
      CustomButtonVariant.primary => WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed)) {
          return colors.primaryDark;
        }
        return colors.primary;
      }),
      CustomButtonVariant.secondary => WidgetStateProperty.resolveWith((
        states,
      ) {
        if (states.contains(WidgetState.pressed)) {
          return colors.ink.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return colors.ink.withValues(alpha: 0.06);
        }
        return colors.white;
      }),
      CustomButtonVariant.ghost => const WidgetStatePropertyAll(
        Colors.transparent,
      ),
    };

    final foregroundColor = switch (variant) {
      CustomButtonVariant.primary => WidgetStatePropertyAll(colors.white),
      CustomButtonVariant.secondary => WidgetStatePropertyAll(colors.ink),
      CustomButtonVariant.ghost => WidgetStatePropertyAll(colors.ink),
    };

    final side = switch (variant) {
      CustomButtonVariant.primary => const WidgetStatePropertyAll(
        BorderSide.none,
      ),
      CustomButtonVariant.secondary => WidgetStatePropertyAll(
        BorderSide(color: colors.ink, width: 2),
      ),
      CustomButtonVariant.ghost => const WidgetStatePropertyAll(
        BorderSide.none,
      ),
    };

    final style =
        ButtonStyle(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: side,
          elevation: const WidgetStatePropertyAll(0),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: context.buttonPaddingHorizontal),
          ),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          textStyle: WidgetStatePropertyAll(
            baseStyle.copyWith(
              letterSpacing: AppSizes.buttonLabelLetterSpacing,
            ),
          ),
        ).copyWith(
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return BorderSide(color: colors.primary, width: 2);
            }
            return side.resolve(states);
          }),
        );

    final effectiveOnPressed = isLoading ? null : onPressed;
    final resolvedFullWidth = fullWidth ?? context.isMobile;
    final labelColor = variant == CustomButtonVariant.primary
        ? colors.white
        : colors.ink;

    Widget content(String text, Widget? trailingIcon) {
      return Row(
        mainAxisSize: resolvedFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: trailingIcon != null && resolvedFullWidth
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Text(text.toUpperCase()),
          if (trailingIcon != null) ...[
            if (!resolvedFullWidth)
              const SizedBox(width: AppSizes.iconSizeInButton),
            IconTheme(
              data: IconThemeData(
                size: AppSizes.iconSizeInButton,
                color: labelColor,
              ),
              child: trailingIcon,
            ),
          ],
        ],
      );
    }

    Widget reserve(String text, Widget? trailingIcon) {
      return ExcludeSemantics(
        child: Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: content(text, trailingIcon),
        ),
      );
    }

    final buttonChild = Stack(
      alignment: Alignment.centerLeft,
      children: [
        reserve(label, icon),
        if (loadingLabel != null) reserve(loadingLabel!, null),
        KeyedSubtree(
          key: const ValueKey('custom_button_visible_content'),
          child: content(
            isLoading ? loadingLabel! : label,
            isLoading ? null : icon,
          ),
        ),
      ],
    );

    final sized = SizedBox(
      width: resolvedFullWidth ? double.infinity : null,
      height: context.buttonHeight,
      child: switch (variant) {
        CustomButtonVariant.primary => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: buttonChild,
        ),
        CustomButtonVariant.secondary => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: buttonChild,
        ),
        CustomButtonVariant.ghost => TextButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: buttonChild,
        ),
      },
    );

    return Opacity(opacity: _isDisabled ? 0.45 : 1, child: sized);
  }
}
