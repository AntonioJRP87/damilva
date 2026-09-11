import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/features/home/domain/entities/home_content.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomeStatus { initial, loading, success, error }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    HomeContent? content,
    AppError? error,
  }) = _HomeState;
}
