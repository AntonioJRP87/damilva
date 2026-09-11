import 'package:damilva/features/home/domain/entities/featured_category.dart';

class FeaturedCategoryRemoteEntity {
  const FeaturedCategoryRemoteEntity({
    required this.id,
    required this.name,
    required this.image,
  });

  factory FeaturedCategoryRemoteEntity.fromJson(Map<String, dynamic> json) {
    return FeaturedCategoryRemoteEntity(
      id: json['id'] as String,
      name: json['nombre'] as String,
      image: json['imagen'] as String,
    );
  }

  final String id;
  final String name;
  final String image;

  FeaturedCategory toDomain() {
    return FeaturedCategory(id: id, name: name, imageUrl: image);
  }
}
