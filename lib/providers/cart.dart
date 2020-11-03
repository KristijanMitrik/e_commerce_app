import 'package:flutter/foundation.dart';
//import 'package:shop_app/widgets/cart_item.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(this.id, this.title, this.quantity, this.price);
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = new Map<String, CartItem>();
  Map<String, CartItem> get items {
    return _items;
  }

  int get itemCount {
    return items == null ? 0 : items.length;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existing) => CartItem(
                existing.id,
                existing.title,
                existing.quantity + 1,
                existing.price,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                DateTime.now().toString(),
                title,
                1,
                price,
              ));
    }
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    items.forEach((key, v) {
      total += v.price * v.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(productId, (existing) {
        CartItem(
            existing.id, existing.title, existing.quantity - 1, existing.price);
      });
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
