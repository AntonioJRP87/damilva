import 'package:damilva/features/product/domain/entities/related_product.dart';

class RelatedProductRemoteEntity {
  const RelatedProductRemoteEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory RelatedProductRemoteEntity.fromJson(Map<String, dynamic> json) {
    return RelatedProductRemoteEntity(
      id: json['id'] as String,
      name: json['nombre'] as String,
      price: (json['precio'] as num).toDouble(),
      image: json['imagen'] as String,
    );
  }

  final String id;
  final String name;
  final double price;
  final String image;

  RelatedProduct toDomain() {
    return RelatedProduct(id: id, name: name, price: price, imageUrl: image);
  }
}
