import 'package:damilva/features/home/domain/entities/carousel_slide.dart';

class CarouselSlideRemoteEntity {
  const CarouselSlideRemoteEntity({
    required this.image,
    required this.kicker,
    required this.title,
    required this.link,
  });

  factory CarouselSlideRemoteEntity.fromJson(Map<String, dynamic> json) {
    return CarouselSlideRemoteEntity(
      image: json['imagen'] as String,
      kicker: json['antetitulo'] as String,
      title: json['titular'] as String,
      link: json['enlace'] as String,
    );
  }

  final String image;
  final String kicker;
  final String title;
  final String link;

  CarouselSlide toDomain() {
    return CarouselSlide(
      imageUrl: image,
      kicker: kicker,
      title: title,
      link: link,
    );
  }
}
