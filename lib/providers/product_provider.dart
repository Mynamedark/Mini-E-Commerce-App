import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final _products = FirebaseFirestore.instance.collection('products');
  List<Product> items = [];
  List<Product> filtered = [];

  void listenProducts() {
    _products.snapshots().listen((snap) {
      items = snap.docs.map((doc) {
        final data = doc.data();
        return Product.fromJson({
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'price': (data['price'] ?? 0).toDouble(),
          'imageUrl': data['imageUrl'] ?? '',
          'category': data['category'],
        });
      }).toList();
      filtered = items;
      notifyListeners();
    });
  }

  void search(String q) {
    if (q.isEmpty) {
      filtered = items;
    } else {
      final lq = q.toLowerCase();
      filtered = items.where((p) =>
      p.title.toLowerCase().contains(lq) ||
          (p.category ?? '').toLowerCase().contains(lq)).toList();
    }
    notifyListeners();
  }

  Product? byId(String id) {
    try {
      return items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
