class CategoryFilters {
  const CategoryFilters({
    required this.sizes,
    required this.colors,
    required this.priceMin,
    required this.priceMax,
  });

  final List<String> sizes;
  final List<String> colors;
  final double priceMin;
  final double priceMax;
}
