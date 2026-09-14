import 'dart:async';

import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/features/header/domain/entities/search_suggestion.dart';
import 'package:damilva/features/header/presentation/bloc/header_bloc.dart';
import 'package:damilva/features/header/presentation/bloc/header_event.dart';
import 'package:damilva/features/header/presentation/bloc/header_state.dart';
import 'package:damilva/shared/widgets/icons/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _debounceDuration = Duration(milliseconds: 300);

class HeaderSearchField extends StatefulWidget {
  const HeaderSearchField({super.key, this.autofocus = false});

  final bool autofocus;

  @override
  State<HeaderSearchField> createState() => _HeaderSearchFieldState();
}

class _HeaderSearchFieldState extends State<HeaderSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _overlayController.show();
    } else {
      _overlayController.hide();
    }
  }

  void _handleChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      context.read<HeaderBloc>().add(HeaderEvent.searchQueryChanged(value));
    });
  }

  void _handleSubmitted(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) return;
    _focusNode.unfocus();
    context.go('/buscar?q=$query');
  }

  void _handleSuggestionTap(SearchSuggestion suggestion) {
    _controller.clear();
    _focusNode.unfocus();
    context.read<HeaderBloc>().add(const HeaderEvent.searchCleared());
    context.go('/p/${suggestion.id}');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;
    final localizations = context.localizations;

    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) {
          return BlocBuilder<HeaderBloc, HeaderState>(
            buildWhen: (previous, current) =>
                previous.suggestions != current.suggestions,
            builder: (context, state) {
              if (state.suggestions.isEmpty) return const SizedBox.shrink();
              return CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, AppSizesSearch.dropdownOffset),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 0,
                    color: colors.white,
                    child: Container(
                      width: 320,
                      constraints: const BoxConstraints(maxHeight: 320),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.ink, width: 1),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: state.suggestions
                            .map(
                              (suggestion) => Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _handleSuggestionTap(suggestion),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      suggestion.name,
                                      style: typography.text13w400.copyWith(
                                        color: colors.ink,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: typography.text14w400.copyWith(color: colors.ink),
            decoration: InputDecoration(
              isDense: true,
              hintText: localizations.header_search_hint,
              hintStyle: typography.text14w400.copyWith(
                color: colors.ink.withValues(alpha: 0.45),
              ),
              prefixIcon: CustomIcon(
                AppIcon.search,
                size: 18,
                color: colors.ink,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  color: colors.ink.withValues(alpha: 0.4),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: colors.primary, width: 2),
              ),
            ),
            onChanged: _handleChanged,
            onSubmitted: _handleSubmitted,
          ),
        ),
      ),
    );
  }
}

abstract class AppSizesSearch {
  static const double dropdownOffset = 4;
}
