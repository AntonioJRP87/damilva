import 'package:damilva/features/header/presentation/widgets/app_shell.dart';
import 'package:damilva/features/home/presentation/page/home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
      ],
    ),
  ],
);
