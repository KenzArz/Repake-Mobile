import 'package:flutter/material.dart';

import '../models/DummyData.dart';
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
    _product = initialProduct ?? DummyData.defaultProduct();
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
    // Prioritas: Gunakan product.images dari DummyData (min 3 images)
    // Fallback: Gunakan primary image jika images kosong
    if (_product.galleryImages.isNotEmpty) {
      _images = List.from(_product.galleryImages);
    } else {
      // Fallback: generate placeholder images jika benar-benar kosong
      _images = [
        'https://images.unsplash.com/photo-1595225476474-87563907a212?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1587829741301-dc798b83add3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1595044426077-d36d9236d54a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ];
    }
  }

  void _initSimilarProducts(List<ProductModel>? products) {
    if (products != null && products.isNotEmpty) {
      _similarProducts = products;
      return;
    }

    // Ambil 4 produk dari DummyData untuk "Similar Products"
    _similarProducts = DummyData.products.take(4).map((p) {
      return p.copyWith(id: 'sim_${p.id}');
    }).toList();
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

  @override
  void dispose() {
    offerController.dispose();
    super.dispose();
  }
}
