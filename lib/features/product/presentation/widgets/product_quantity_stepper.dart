import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class ProductQuantityStepper extends StatelessWidget {
  const ProductQuantityStepper({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final int maxQuantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(label: '−', onPressed: quantity > 1 ? onDecrement : null),
        SizedBox(
          width: AppSizes.productQuantityButtonSize,
          height: AppSizes.productQuantityButtonSize,
          child: Center(
            child: Text(
              '$quantity',
              style: typography.text14w800.copyWith(color: colors.ink),
            ),
          ),
        ),
        _StepButton(
          label: '+',
          onPressed: quantity < maxQuantity ? onIncrement : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Opacity(
      opacity: onPressed == null ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: AppSizes.productQuantityButtonSize,
            height: AppSizes.productQuantityButtonSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: colors.ink, width: 2),
            ),
            child: Text(
              label,
              style: typography.text14w800.copyWith(color: colors.ink),
            ),
          ),
        ),
      ),
    );
  }
}
