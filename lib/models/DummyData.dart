import 'BannerModel.dart';
import 'CategoryModel.dart';
import 'ProductModel.dart';
import 'ReportModel.dart';

/// Centralized Dummy Data untuk Development & Testing.
/// Single source of truth untuk semua dummy data di aplikasi.
///
/// CARA PAKAI:
/// ```dart
/// import '../../models/DummyData.dart';
///
/// final products = DummyData.products;
/// final categories = DummyData.categories;
/// final banners = DummyData.banners;
/// ```
class DummyData {
  DummyData._(); // Private constructor untuk prevent instantiation

  // =========================================================================
  // CATEGORIES DATA
  // =========================================================================

  /// 6 Kategori Produk dengan Icon URLs dari Unsplash.
  /// Icon dipilih yang relevan dengan kategori masing-masing.
  static final List<CategoryModel> categories = [
    CategoryModel(
      id: 'cat_001',
      name: 'Elektronik',
      iconUrl:
          'https://images.unsplash.com/photo-1550009158-9ebf69173e03?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    ),
    CategoryModel(
      id: 'cat_002',
      name: 'Pakaian',
      iconUrl:
          'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    ),
    CategoryModel(
      id: 'cat_003',
      name: 'Perabot',
      iconUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    ),
    CategoryModel(
      id: 'cat_004',
      name: 'Olahraga',
      iconUrl:
          'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    ),
    CategoryModel(
      id: 'cat_005',
      name: 'Buku',
      iconUrl:
          'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    ),
    CategoryModel(
      id: 'cat_006',
      name: 'Lainnya',
      iconUrl:
          'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
    ),
  ];

  // =========================================================================
  // BANNERS DATA
  // =========================================================================

  /// 3 Banner untuk Home Screen Slider.
  /// Banner menampilkan promo atau campaign RePake.
  static final List<BannerModel> banners = [
    BannerModel(
      id: 'banner_001',
      title: 'Welcome to RePake',
      imagePath:
          'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
      isActive: true,
    ),
    BannerModel(
      id: 'banner_002',
      title: 'Best Deals Today',
      imagePath:
          'https://images.unsplash.com/photo-1607082349566-187342175e2f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
      isActive: true,
    ),
    BannerModel(
      id: 'banner_003',
      title: 'New Arrivals',
      imagePath:
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
      isActive: true,
    ),
  ];

  // =========================================================================
  // PRODUCTS DATA
  // =========================================================================

  /// 5 Produk Dummy dengan Data Realistic & Beragam.
  /// Setiap produk memiliki 3 images untuk gallery di detail page.
  /// Digunakan sebagai master data untuk semua screens.
  static final List<ProductModel> products = [
    ProductModel(
      id: 'prod_001',
      title: 'Keyboard Mechanical RGB Gaming Bekas Mulus',
      price: 450000,
      sellerName: 'TechStore_ID',
      location: 'Jakarta Pusat',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      condition: 'Seperti baru',
      status: 'Dijual',
      images: [
        'https://images.unsplash.com/photo-1595225476474-87563907a212?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1587829741301-dc798b83add3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1595044426077-d36d9236d54a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      isFavorite: false,
    ),
    ProductModel(
      id: 'prod_002',
      title: 'Sepatu Sneakers Nike Air Force 1 Original Second',
      price: 850000,
      sellerName: 'Midou_kun',
      location: 'Bekasi',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      condition: 'Dirawat dengan baik',
      status: 'Dijual',
      images: [
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1605348532760-6753d2c43329?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      isFavorite: false,
    ),
    ProductModel(
      id: 'prod_003',
      title: 'Jaket Denim Vintage 90s Unisex Thrift Premium',
      price: 180000,
      sellerName: 'VintageKuy',
      location: 'Bandung',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      condition: 'Bekas pakai',
      status: 'Dijual',
      images: [
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1576566588028-4147f3842f27?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1578932750294-f5075e85f44a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      isFavorite: false,
    ),
    ProductModel(
      id: 'prod_004',
      title: 'Kamera DSLR Canon EOS 70D Fullset Box Like New',
      price: 4500000,
      sellerName: 'CameraBekas_Pro',
      location: 'Tangerang',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      condition: 'Seperti baru',
      status: 'Dijual',
      images: [
        'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1606980624923-5d279670e5f7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1617005082133-548c4dd27f35?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      isFavorite: false,
    ),
    ProductModel(
      id: 'prod_005',
      title: 'Headphone Sony WH-1000XM4 Wireless Noise Cancelling',
      price: 2800000,
      sellerName: 'AudioMania',
      location: 'Depok',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      condition: 'Dirawat dengan baik',
      status: 'Dijual',
      images: [
        'https://images.unsplash.com/photo-1546435770-a3e426bf472b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ],
      isFavorite: false,
    ),
  ];

  /// Ambil produk untuk section "Nearby" (duplikasi dengan ID berbeda).
  static List<ProductModel> productsNearby(int count) {
    final result = <ProductModel>[];
    for (int i = 0; i < count && i < products.length; i++) {
      result.add(products[i].copyWith(id: 'nearby_$i'));
    }
    return result;
  }

  /// Ambil produk untuk section "Latest" (duplikasi dengan ID berbeda).
  static List<ProductModel> productsLatest(int count) {
    final result = <ProductModel>[];
    for (int i = 0; i < count; i++) {
      final sourceProduct = products[i % products.length];
      result.add(sourceProduct.copyWith(id: 'latest_$i'));
    }
    return result;
  }

  /// Ambil produk untuk Favorite screen (semua marked as favorite).
  static List<ProductModel> productsFavorites() {
    return products
        .map((p) => p.copyWith(
              id: 'fav_${p.id}',
              isFavorite: true,
            ))
        .toList();
  }

  /// Ambil 1 produk default untuk detail page.
  static ProductModel defaultProduct() {
    return products[0];
  }

  /// Ambil produk untuk Seller Profile (customize seller name & location).
  /// Mengembalikan semua 5 produk dengan seller name & location yang di-override.
  static List<ProductModel> productsForSeller(
      String sellerName, String location) {
    return products.map((p) {
      return p.copyWith(
        id: 'seller_${p.id}',
        sellerName: sellerName,
        location: location,
      );
    }).toList();
  }

  // =========================================================================
  // REPORTS DATA
  // =========================================================================

  /// 5 Report Dummy untuk Admin Dashboard.
  /// Setiap report mereferensikan produk dari DummyData.products.
  static final List<ReportModel> reports = [
    ReportModel(
      id: 'report_001',
      product: products[0], // Keyboard Mechanical
      reporterName: 'Reza Auditore',
      type: ReportType.misleading,
      description:
          'Deskripsi produk tidak sesuai dengan kondisi sebenarnya. Gambar terlihat sangat baru tapi kenyataannya banyak lecet.',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ReportModel(
      id: 'report_002',
      product: products[1], // Sepatu Sneakers Nike
      reporterName: 'Siti Nurhaliza',
      type: ReportType.fraud,
      description:
          'Penjual meminta transfer di luar aplikasi dan tidak merespons chat setelah transfer dilakukan.',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    ReportModel(
      id: 'report_003',
      product: products[2], // Jaket Denim Vintage
      reporterName: 'Ahmad Dhani',
      type: ReportType.spam,
      description:
          'Produk yang sama diposting berkali-kali dengan akun berbeda. Mencurigakan.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ReportModel(
      id: 'report_004',
      product: products[3], // Kamera DSLR Canon
      reporterName: 'Bunga Citra Lestari',
      type: ReportType.prohibited,
      description:
          'Produk yang dijual kemungkinan adalah hasil pencurian berdasarkan serial number yang dilaporkan hilang.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReportModel(
      id: 'report_005',
      product: products[4], // Headphone Sony
      reporterName: 'Raisa Andriana',
      type: ReportType.other,
      description:
          'Penjual menggunakan kata-kata kasar saat bernegosiasi dan tidak sopan dalam berkomunikasi.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // =========================================================================
  // HELPER METHODS - CATEGORIES
  // =========================================================================

  /// Ambil category by ID.
  static CategoryModel? getCategoryById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // =========================================================================
  // HELPER METHODS - BANNERS
  // =========================================================================

  /// Ambil hanya banner yang active untuk ditampilkan.
  static List<BannerModel> get activeBanners {
    return banners.where((b) => b.isActive).toList();
  }

  /// Ambil banner image URLs untuk BannerSlider widget.
  static List<String> get bannerImageUrls {
    return activeBanners
        .where((b) => b.imagePath != null && b.imagePath!.isNotEmpty)
        .map((b) => b.imagePath!)
        .toList();
  }
}
