import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/features/header/presentation/bloc/header_bloc.dart';
import 'package:damilva/features/header/presentation/bloc/header_event.dart';
import 'package:damilva/features/header/presentation/widgets/header_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderMobileSearchPanel extends StatelessWidget {
  const HeaderMobileSearchPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final localizations = context.localizations;

    return ColoredBox(
      color: colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsiveMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: HeaderSearchField(
                      key: ValueKey('mobile-search'),
                      autofocus: true,
                    ),
                  ),
                  IconButton(
                    tooltip: localizations.close,
                    onPressed: () => context.read<HeaderBloc>().add(
                      const HeaderEvent.mobileSearchClosed(),
                    ),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
