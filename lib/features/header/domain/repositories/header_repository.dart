import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/header/domain/entities/category.dart';
import 'package:damilva/features/header/domain/entities/search_suggestion.dart';

abstract class HeaderRepositoryContract {
  Future<Result<List<Category>, AppError>> getCategories();
  Future<Result<List<SearchSuggestion>, AppError>> getSearchSuggestions(
    String query,
  );
}
