import 'package:flutter/foundation.dart';

import '../models/ProductModel.dart';
import 'ProductDetailController.dart';

export 'ProductDetailController.dart';

/// Controller utama untuk entitas Produk (MVC Architecture).
///
/// Mengelola daftar produk, produk sekitar (nearby), produk terbaru,
/// pencarian, serta pembuatan produk baru.
class ProductController extends ChangeNotifier {
  ProductController._();
  static final ProductController instance = ProductController._();

  final List<ProductModel> _products = [
    ProductDetailController.createDefaultProduct(),
  ];

  List<ProductModel> get products => List.unmodifiable(_products);

  void addProduct(ProductModel product) {
    _products.insert(0, product);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final current = _products[index];
      _products[index] = current.copyWith(isFavorite: !current.isFavorite);
      notifyListeners();
    }
  }
}
