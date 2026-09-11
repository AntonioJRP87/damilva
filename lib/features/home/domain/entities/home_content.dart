import 'package:damilva/features/home/domain/entities/carousel_slide.dart';
import 'package:damilva/features/home/domain/entities/featured_category.dart';
import 'package:damilva/features/home/domain/entities/home_product.dart';

class HomeContent {
  const HomeContent({
    required this.carousel,
    required this.newArrivals,
    required this.featuredCategories,
    required this.freeShippingThreshold,
  });

  final List<CarouselSlide> carousel;
  final List<HomeProduct> newArrivals;
  final List<FeaturedCategory> featuredCategories;
  final double freeShippingThreshold;
}
