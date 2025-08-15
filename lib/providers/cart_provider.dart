import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {}; // key: productId

  List<CartItem> get items => _items.values.toList();
  double get total => _items.values.fold(0.0, (p, e) => p + e.price * e.quantity);

  void add(CartItem item) {
    if (_items.containsKey(item.productId)) {
      _items[item.productId]!.quantity++;
    } else {
      _items[item.productId] = item;
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQty(String productId, int qty) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity = qty.clamp(1, 99);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
