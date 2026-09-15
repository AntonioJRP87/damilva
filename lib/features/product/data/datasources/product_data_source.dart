import 'package:damilva/features/product/data/models/product_detail_remote_entity.dart';

abstract class ProductDataSourceContract {
  Future<ProductDetailRemoteEntity> getProduct(String id);

  Future<void> addToCart({required String sku, required int quantity});
}
