// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:damilva/core/di/app_di.dart' as di;
import 'package:damilva/core/di/presentation_di.dart';
import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/home/domain/entities/home_content.dart';
import 'package:damilva/features/home/domain/usecases/get_home_use_case.dart';
import 'package:damilva/features/home/presentation/bloc/home_bloc.dart';
import 'package:damilva/main.dart';

/// No real backend exists yet: stub the use case so this smoke test never
/// makes a network call (which would leave a pending timer behind).
class _FakeGetHomeUseCase implements GetHomeUseCaseContract {
  @override
  Future<Result<HomeContent, AppError>> call() async {
    return const Result.failure(AppError.unknown());
  }
}

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await di.init();
    presentationDi.unregister<HomeBloc>();
    presentationDi.registerFactory<HomeBloc>(
      () => HomeBloc(_FakeGetHomeUseCase()),
    );

    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
