import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class ProductInfoAccordion extends StatefulWidget {
  const ProductInfoAccordion({
    super.key,
    required this.description,
    required this.composition,
    required this.returnsInfo,
  });

  final String description;
  final String composition;
  final String returnsInfo;

  @override
  State<ProductInfoAccordion> createState() => _ProductInfoAccordionState();
}

class _ProductInfoAccordionState extends State<ProductInfoAccordion> {
  int? _openIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;

    final sections = [
      (
        title: localizations.product_section_description,
        body: widget.description,
      ),
      (
        title: localizations.product_section_composition,
        body: widget.composition,
      ),
      (title: localizations.product_section_returns, body: widget.returnsInfo),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sections.length; i++)
          _AccordionSection(
            title: sections[i].title,
            body: sections[i].body,
            isOpen: _openIndex == i,
            onTap: () =>
                setState(() => _openIndex = _openIndex == i ? null : i),
          ),
      ],
    );
  }
}

class _AccordionSection extends StatelessWidget {
  const _AccordionSection({
    required this.title,
    required this.body,
    required this.isOpen,
    required this.onTap,
  });

  final String title;
  final String body;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.ink.withValues(
              alpha: AppSizes.dataTableRowDividerAlpha,
            ),
            width: AppSizes.dataTableRowDividerWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.productAccordionPaddingVertical,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: typography.text16w800.copyWith(color: colors.ink),
                    ),
                    Text(
                      isOpen ? '−' : '+',
                      style: typography.text16w800.copyWith(color: colors.ink),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.only(
                bottom: AppSizes.productAccordionPaddingVertical,
              ),
              child: Text(
                body,
                style: typography.text14w400.copyWith(color: colors.ink),
              ),
            ),
        ],
      ),
    );
  }
}
