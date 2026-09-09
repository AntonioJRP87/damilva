import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T, E> with _$Result<T, E> {
  const factory Result.success(T data) = Success<T, E>;

  const factory Result.failure(E error) = Failure<T, E>;

  const Result._();

  bool get isSuccess => this is Success<T, E>;

  bool get isFailure => this is Failure<T, E>;

  T? get data => isSuccess ? (this as Success<T, E>).data : null;

  E? get error => isFailure ? (this as Failure<T, E>).error : null;
}
