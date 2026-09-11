import 'package:damilva/features/home/data/models/carousel_slide_remote_entity.dart';
import 'package:damilva/features/home/data/models/featured_category_remote_entity.dart';
import 'package:damilva/features/home/data/models/home_product_remote_entity.dart';
import 'package:damilva/features/home/domain/entities/home_content.dart';

class HomeRemoteEntity {
  const HomeRemoteEntity({
    required this.carousel,
    required this.newArrivals,
    required this.featuredCategories,
    required this.freeShippingThreshold,
  });

  factory HomeRemoteEntity.fromJson(Map<String, dynamic> json) {
    final config = json['config'] as Map<String, dynamic>;
    return HomeRemoteEntity(
      carousel: (json['carrusel'] as List)
          .map(
            (e) =>
                CarouselSlideRemoteEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      newArrivals: (json['novedades'] as List)
          .map(
            (e) => HomeProductRemoteEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      featuredCategories: (json['categoriasDestacadas'] as List)
          .map(
            (e) => FeaturedCategoryRemoteEntity.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      freeShippingThreshold: (config['umbralEnvioGratis'] as num).toDouble(),
    );
  }

  final List<CarouselSlideRemoteEntity> carousel;
  final List<HomeProductRemoteEntity> newArrivals;
  final List<FeaturedCategoryRemoteEntity> featuredCategories;
  final double freeShippingThreshold;

  HomeContent toDomain() {
    return HomeContent(
      carousel: carousel.map((e) => e.toDomain()).toList(),
      newArrivals: newArrivals.map((e) => e.toDomain()).toList(),
      featuredCategories: featuredCategories.map((e) => e.toDomain()).toList(),
      freeShippingThreshold: freeShippingThreshold,
    );
  }
}
