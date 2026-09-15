import 'package:damilva/features/category/presentation/page/category_list_page.dart';
import 'package:damilva/features/category/presentation/utils/category_filter_query.dart';
import 'package:damilva/features/header/presentation/widgets/app_shell.dart';
import 'package:damilva/features/home/presentation/page/home_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/c/:categoria',
          builder: (context, state) => CategoryListPage(
            key: ValueKey(state.uri.toString()),
            categoryId: state.pathParameters['categoria'],
            categoryName: state.extra as String?,
            filters: CategoryFilterQuery.fromQueryParameters(
              state.uri.queryParameters,
            ),
          ),
        ),
        GoRoute(
          path: '/buscar',
          builder: (context, state) => CategoryListPage(
            key: ValueKey(state.uri.toString()),
            searchQuery: state.uri.queryParameters['q'] ?? '',
            filters: CategoryFilterQuery.fromQueryParameters(
              state.uri.queryParameters,
            ),
          ),
        ),
      ],
    ),
  ],
);
