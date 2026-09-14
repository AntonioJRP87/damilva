import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/result/result.dart';
import 'package:damilva/features/header/domain/entities/search_suggestion.dart';
import 'package:damilva/features/header/domain/repositories/header_repository.dart';

abstract class GetSearchSuggestionsUseCaseContract {
  Future<Result<List<SearchSuggestion>, AppError>> call(String query);
}

class GetSearchSuggestionsUseCase
    implements GetSearchSuggestionsUseCaseContract {
  GetSearchSuggestionsUseCase(this._headerRepository);

  final HeaderRepositoryContract _headerRepository;

  @override
  Future<Result<List<SearchSuggestion>, AppError>> call(String query) {
    return _headerRepository.getSearchSuggestions(query);
  }
}
