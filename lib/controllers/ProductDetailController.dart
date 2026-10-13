import 'package:flutter/material.dart';

import '../models/ProductModel.dart';

/// Controller untuk Halaman Detail Produk (MVC Architecture).
///
/// Mengelola seluruh business logic, state produk, penawaran harga,
/// interaksi galeri foto, status favorit, serta daftar rekomendasi produk serupa.
class ProductDetailController extends ChangeNotifier {
  ProductDetailController({
    ProductModel? initialProduct,
    List<ProductModel>? similarProducts,
  }) {
    _product = initialProduct ?? createDefaultProduct();
    _isFavorite = _product.isFavorite;

    _initImages();
    _initSimilarProducts(similarProducts);

    offerController = TextEditingController(
      text: formatRupiahDigits(_product.price),
    );
  }

  late ProductModel _product;
  late bool _isFavorite;
  int _selectedImageIndex = 0;
  late List<String> _images;
  late List<ProductModel> _similarProducts;

  /// Controller untuk input penawaran harga
  late final TextEditingController offerController;

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  ProductModel get product => _product;
  bool get isFavorite => _isFavorite;
  int get selectedImageIndex => _selectedImageIndex;
  List<String> get images => _images;
  List<ProductModel> get similarProducts => _similarProducts;
  String get activeImageUrl => _images[_selectedImageIndex];

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------

  void _initImages() {
    final primaryImg =
        (_product.imageUrl != null && _product.imageUrl!.isNotEmpty)
            ? _product.imageUrl!
            : 'https://images.unsplash.com/photo-1595225476474-87563907a212?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80';

    _images = [
      primaryImg,
      'https://images.unsplash.com/photo-1587829741301-dc798b83add3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1595044426077-d36d9236d54a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    ];
  }

  void _initSimilarProducts(List<ProductModel>? products) {
    if (products != null && products.isNotEmpty) {
      _similarProducts = products;
      return;
    }

    _similarProducts = List.generate(
      4,
      (index) => ProductModel(
        id: 'sim_${index + 1}',
        title: 'Keyboad pemda bekas\nreza auditore asli no hoax',
        price: 670000,
        sellerName: 'Midou_kun',
        location: 'Bekasi',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        condition: 'Dirawat dengan baik',
        status: 'Dijual',
        imageUrl:
            'https://images.unsplash.com/photo-1595225476474-87563907a212?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIONS / BUSINESS LOGIC
  // ---------------------------------------------------------------------------

  /// Mengganti gambar yang aktif ditampilkan di banner
  void selectImage(int index) {
    if (index >= 0 && index < _images.length && index != _selectedImageIndex) {
      _selectedImageIndex = index;
      notifyListeners();
    }
  }

  /// Mengubah status favorit produk
  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    _product = _product.copyWith(isFavorite: _isFavorite);
    notifyListeners();
  }

  /// Menetapkan penawaran harga
  void setOfferAmount(int amount) {
    offerController.text = formatRupiahDigits(amount);
    notifyListeners();
  }

  /// Memvalidasi dan memproses pengajuan tawar harga
  /// Return string hasil/pesan sukses atau null jika input tidak valid.
  String? submitOffer() {
    final text = offerController.text.trim();
    if (text.isEmpty) {
      return null;
    }
    return '🏷️ Penawaran Rp $text berhasil diajukan ke ${_product.sellerName}!';
  }

  /// Helper untuk membuat format rupiah (contoh: 670000 -> "670.000")
  static String formatRupiahDigits(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => '.',
        );
  }

  /// Data produk default jika tidak ada parameter yang dipassing
  static ProductModel createDefaultProduct() {
    return ProductModel(
      id: 'default_product_detail',
      title: 'Keyboard pemda bekas reza\nauditore asli no hoax',
      price: 670000,
      sellerName: 'Midou_kun',
      location: 'Bekasi',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      condition: 'Dirawat dengan baik',
      status: 'Dijual',
      imageUrl:
          'https://images.unsplash.com/photo-1595225476474-87563907a212?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      isFavorite: false,
    );
  }

  @override
  void dispose() {
    offerController.dispose();
    super.dispose();
  }
}
