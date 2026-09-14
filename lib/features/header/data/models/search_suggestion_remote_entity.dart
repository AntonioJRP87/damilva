import 'package:damilva/features/header/domain/entities/search_suggestion.dart';

class SearchSuggestionRemoteEntity {
  const SearchSuggestionRemoteEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory SearchSuggestionRemoteEntity.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionRemoteEntity(
      id: json['id'] as String,
      name: json['nombre'] as String,
      imageUrl: json['imagen'] as String,
    );
  }

  final String id;
  final String name;
  final String imageUrl;

  SearchSuggestion toDomain() =>
      SearchSuggestion(id: id, name: name, imageUrl: imageUrl);
}
