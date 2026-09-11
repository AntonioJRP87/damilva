import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/home/domain/entities/home_content.dart';
import 'package:damilva/features/home/domain/usecases/get_home_use_case.dart';
import 'package:damilva/features/home/presentation/bloc/home_bloc.dart';
import 'package:damilva/features/home/presentation/bloc/home_event.dart';
import 'package:damilva/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGetHomeUseCase implements GetHomeUseCaseContract {
  _FakeGetHomeUseCase(this.result);

  final Result<HomeContent, AppError> result;

  @override
  Future<Result<HomeContent, AppError>> call() async => result;
}

const _content = HomeContent(
  carousel: [],
  newArrivals: [],
  featuredCategories: [],
  freeShippingThreshold: 40,
);

void main() {
  test('emits loading then success when the use case succeeds', () async {
    final bloc = HomeBloc(
      _FakeGetHomeUseCase(const Result.success(_content)),
    );
    addTearDown(bloc.close);

    final states = <HomeState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const HomeEvent.started());
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(states[0].status, HomeStatus.loading);
    expect(states[1].status, HomeStatus.success);
    expect(states[1].content, _content);
  });

  test('emits loading then error when the use case fails', () async {
    final bloc = HomeBloc(
      _FakeGetHomeUseCase(const Result.failure(AppError.noInternetConnection())),
    );
    addTearDown(bloc.close);

    final states = <HomeState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(const HomeEvent.started());
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(states[0].status, HomeStatus.loading);
    expect(states[1].status, HomeStatus.error);
    expect(states[1].error, const AppError.noInternetConnection());
  });

  test('refreshed re-fetches the same way as started', () async {
    final bloc = HomeBloc(
      _FakeGetHomeUseCase(const Result.success(_content)),
    );
    addTearDown(bloc.close);

    bloc.add(const HomeEvent.refreshed());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, HomeStatus.success);
  });
}
