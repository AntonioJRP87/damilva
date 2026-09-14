import 'package:damilva/core/di/presentation_di.dart';
import 'package:damilva/features/header/presentation/bloc/header_bloc.dart';
import 'package:damilva/features/header/presentation/bloc/header_event.dart';
import 'package:damilva/features/header/presentation/bloc/header_state.dart';
import 'package:damilva/features/header/presentation/widgets/app_header.dart';
import 'package:damilva/features/header/presentation/widgets/header_mobile_menu_panel.dart';
import 'package:damilva/features/header/presentation/widgets/header_mobile_search_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final HeaderBloc _headerBloc = presentationDi<HeaderBloc>();

  @override
  void initState() {
    super.initState();
    _headerBloc.add(const HeaderEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _headerBloc,
      child: Scaffold(
        body: BlocBuilder<HeaderBloc, HeaderState>(
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    const AppHeader(),
                    Expanded(child: widget.child),
                  ],
                ),
                if (state.isMobileMenuOpen)
                  Positioned.fill(
                    child: HeaderMobileMenuPanel(
                      categories: state.categories,
                      isLoggedIn: state.isLoggedIn,
                      firstName: state.firstName,
                    ),
                  ),
                if (state.isMobileSearchOpen)
                  const Positioned.fill(child: HeaderMobileSearchPanel()),
              ],
            );
          },
        ),
      ),
    );
  }
}
