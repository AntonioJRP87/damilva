import 'package:damilva/features/header/domain/entities/category.dart';
import 'package:damilva/features/header/domain/entities/search_suggestion.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'header_state.freezed.dart';

@freezed
abstract class HeaderState with _$HeaderState {
  const factory HeaderState({
    @Default([]) List<Category> categories,
    @Default('') String searchQuery,
    @Default([]) List<SearchSuggestion> suggestions,
    @Default(false) bool isMobileMenuOpen,
    @Default(false) bool isMobileSearchOpen,
    @Default(false) bool isLoggedIn,
    String? firstName,
    @Default(0) int cartItemsCount,
  }) = _HeaderState;
}
