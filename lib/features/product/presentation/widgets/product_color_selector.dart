import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/hex_color_parser.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class ProductColorSelector extends StatelessWidget {
  const ProductColorSelector({
    super.key,
    required this.colors,
    required this.colorHexOf,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final List<String> colors;
  final String Function(String color) colorHexOf;
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final colorsTheme = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              localizations.category_filter_color,
              style: typography.text14w800.copyWith(color: colorsTheme.ink),
            ),
            if (selectedColor != null) ...[
              const SizedBox(width: AppSizes.categoryFilterOptionSpacing),
              Text(
                selectedColor!,
                style: typography.text14w400.copyWith(color: colorsTheme.ink),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSizes.productSelectorSpacing),
        Wrap(
          spacing: AppSizes.productSelectorSpacing,
          runSpacing: AppSizes.productSelectorSpacing,
          children: [
            for (final color in colors)
              Semantics(
                button: true,
                selected: color == selectedColor,
                label: color,
                child: GestureDetector(
                  onTap: () => onColorSelected(color),
                  child: Container(
                    width: AppSizes.productSwatchSize,
                    height: AppSizes.productSwatchSize,
                    padding: const EdgeInsets.all(
                      AppSizes.productSwatchInnerPadding,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color == selectedColor
                            ? colorsTheme.primary
                            : colorsTheme.ink.withValues(alpha: 0.3),
                        width: color == selectedColor
                            ? AppSizes.productSwatchBorderWidthSelected
                            : AppSizes.productSwatchBorderWidth,
                      ),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColorParser.parse(colorHexOf(color)),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
