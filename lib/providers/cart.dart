import 'package:flutter/foundation.dart';

class CartItem {
  final String cId;
  final String cTitle;
  final double cPrice;
  final int cQuantity;

  CartItem({
    @required this.cId,
    @required this.cTitle,
    @required this.cPrice,
    @required this.cQuantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.cPrice * cartItem.cQuantity;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existItem) => CartItem(
          cId: existItem.cId,
          cTitle: existItem.cTitle,
          cPrice: existItem.cPrice,
          cQuantity: existItem.cQuantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          cId: DateTime.now().toString(),
          cTitle: title,
          cPrice: price,
          cQuantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeItemFromCart(String producId) {
    if (!_items.containsKey(producId)) {
      return;
    }
    if (_items[producId].cQuantity > 1) {
      _items.update(
        producId,
        (existingProd) => CartItem(
            cId: existingProd.cId,
            cTitle: existingProd.cTitle,
            cPrice: existingProd.cPrice,
            cQuantity: existingProd.cQuantity - 1),
      );
    } else {
      _items.remove(producId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
