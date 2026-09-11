import 'package:damilva/features/home/domain/usecases/get_home_use_case.dart';
import 'package:damilva/features/home/presentation/bloc/home_event.dart';
import 'package:damilva/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getHomeUseCase) : super(const HomeState()) {
    on<HomeEvent>((event, emit) {
      return switch (event) {
        Started() => _onFetch(emit),
        Refreshed() => _onFetch(emit),
      };
    });
  }

  final GetHomeUseCaseContract _getHomeUseCase;

  Future<void> _onFetch(Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await _getHomeUseCase();
    if (result.isSuccess) {
      emit(state.copyWith(status: HomeStatus.success, content: result.data));
    }
    if (result.isFailure) {
      emit(state.copyWith(status: HomeStatus.error, error: result.error));
    }
  }
}
