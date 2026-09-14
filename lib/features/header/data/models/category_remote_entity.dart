import 'package:damilva/features/header/domain/entities/category.dart';

class CategoryRemoteEntity {
  const CategoryRemoteEntity({
    required this.id,
    required this.name,
    required this.order,
    required this.visible,
  });

  factory CategoryRemoteEntity.fromJson(Map<String, dynamic> json) {
    return CategoryRemoteEntity(
      id: json['id'] as String,
      name: json['nombre'] as String,
      order: json['orden'] as int,
      visible: json['visible'] as bool,
    );
  }

  final String id;
  final String name;
  final int order;
  final bool visible;

  Category toDomain() => Category(id: id, name: name);
}
