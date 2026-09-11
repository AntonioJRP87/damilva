import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class CustomNoticeBox extends StatelessWidget {
  const CustomNoticeBox({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
  });

  final Widget icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: colors.primary,
          width: AppSizes.noticeBoxBorderWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.noticeBoxPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTheme(
              data: IconThemeData(
                size: context.noticeBoxIconSize,
                color: colors.primary,
              ),
              child: icon,
            ),
            const SizedBox(width: AppSizes.noticeBoxContentSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: typography.text15w800.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSizes.noticeBoxTextSpacing),
                  Text(
                    detail,
                    style: typography.text13w400.copyWith(color: colors.ink),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
