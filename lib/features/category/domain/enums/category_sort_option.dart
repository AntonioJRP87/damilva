enum CategorySortOption { newestFirst, priceAsc, priceDesc }

extension CategorySortOptionWire on CategorySortOption {
  String get wireValue => switch (this) {
    CategorySortOption.newestFirst => 'novedades',
    CategorySortOption.priceAsc => 'precioAsc',
    CategorySortOption.priceDesc => 'precioDesc',
  };

  static CategorySortOption fromWireValue(String? value) => switch (value) {
    'precioAsc' => CategorySortOption.priceAsc,
    'precioDesc' => CategorySortOption.priceDesc,
    _ => CategorySortOption.newestFirst,
  };
}
