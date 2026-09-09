import 'package:damilva/presentation/screens/home/page/home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => const HomePage())],
);
