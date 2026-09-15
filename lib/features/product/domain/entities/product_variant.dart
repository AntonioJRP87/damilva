class ProductVariant {
  const ProductVariant({
    required this.color,
    required this.colorHex,
    required this.size,
    required this.sku,
    required this.stock,
    required this.price,
  });

  final String color;
  final String colorHex;
  final String size;
  final String sku;
  final int stock;
  final double price;

  bool get soldOut => stock <= 0;
}
