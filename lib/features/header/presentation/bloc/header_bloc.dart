import 'package:damilva/features/header/domain/usecases/get_categories_use_case.dart';
import 'package:damilva/features/header/domain/usecases/get_search_suggestions_use_case.dart';
import 'package:damilva/features/header/presentation/bloc/header_event.dart';
import 'package:damilva/features/header/presentation/bloc/header_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _searchSuggestionsMinQueryLength = 3;

class HeaderBloc extends Bloc<HeaderEvent, HeaderState> {
  HeaderBloc(this._getCategoriesUseCase, this._getSearchSuggestionsUseCase)
    : super(const HeaderState()) {
    on<HeaderEvent>((event, emit) {
      return switch (event) {
        HeaderStarted() => _onStarted(emit),
        HeaderSearchQueryChanged() => _onSearchQueryChanged(event, emit),
        HeaderSearchCleared() => _onSearchCleared(emit),
        HeaderMobileMenuOpened() => _onMobileMenuOpened(emit),
        HeaderMobileMenuClosed() => _onMobileMenuClosed(emit),
        HeaderMobileSearchOpened() => _onMobileSearchOpened(emit),
        HeaderMobileSearchClosed() => _onMobileSearchClosed(emit),
        HeaderSessionEnded() => _onSessionEnded(emit),
      };
    });
  }

  final GetCategoriesUseCaseContract _getCategoriesUseCase;
  final GetSearchSuggestionsUseCaseContract _getSearchSuggestionsUseCase;

  Future<void> _onStarted(Emitter<HeaderState> emit) async {
    final result = await _getCategoriesUseCase();
    if (result.isSuccess) {
      emit(state.copyWith(categories: result.data!));
    }
  }

  Future<void> _onSearchQueryChanged(
    HeaderSearchQueryChanged event,
    Emitter<HeaderState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    if (event.query.trim().length < _searchSuggestionsMinQueryLength) {
      emit(state.copyWith(suggestions: const []));
      return;
    }
    final result = await _getSearchSuggestionsUseCase(event.query);
    emit(
      state.copyWith(suggestions: result.isSuccess ? result.data! : const []),
    );
  }

  void _onSearchCleared(Emitter<HeaderState> emit) {
    emit(state.copyWith(searchQuery: '', suggestions: const []));
  }

  void _onMobileMenuOpened(Emitter<HeaderState> emit) {
    emit(state.copyWith(isMobileMenuOpen: true, isMobileSearchOpen: false));
  }

  void _onMobileMenuClosed(Emitter<HeaderState> emit) {
    emit(state.copyWith(isMobileMenuOpen: false));
  }

  void _onMobileSearchOpened(Emitter<HeaderState> emit) {
    emit(state.copyWith(isMobileSearchOpen: true, isMobileMenuOpen: false));
  }

  void _onMobileSearchClosed(Emitter<HeaderState> emit) {
    emit(
      state.copyWith(
        isMobileSearchOpen: false,
        searchQuery: '',
        suggestions: const [],
      ),
    );
  }

  void _onSessionEnded(Emitter<HeaderState> emit) {
    emit(state.copyWith(isLoggedIn: false, firstName: null));
  }
}
