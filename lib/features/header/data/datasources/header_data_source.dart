import 'package:damilva/features/header/data/models/category_remote_entity.dart';
import 'package:damilva/features/header/data/models/search_suggestion_remote_entity.dart';

abstract class HeaderDataSourceContract {
  Future<List<CategoryRemoteEntity>> getCategories();
  Future<List<SearchSuggestionRemoteEntity>> getSearchSuggestions(String query);
}
