import 'dart:async';

class CartBadgeController {
  final _itemsAddedController = StreamController<int>.broadcast();

  Stream<int> get itemsAdded => _itemsAddedController.stream;

  void notifyItemsAdded(int quantity) => _itemsAddedController.add(quantity);

  void dispose() => _itemsAddedController.close();
}
