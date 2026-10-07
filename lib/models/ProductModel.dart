class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.sellerName,
    required this.location,
    required this.createdAt,
    required this.condition,
    this.status = 'Dijual',
    this.imageUrl,
    this.sellerAvatarUrl,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final int price; // dalam Rupiah, contoh: 670000
  final String sellerName;
  final String? sellerAvatarUrl;
  final String location;
  final DateTime createdAt;
  final String condition; // contoh: "Dirawat dengan baik"
  final String status; // contoh: "Dijual"
  final String? imageUrl;
  final bool isFavorite;

  ProductModel copyWith({bool? isFavorite}) {
    return ProductModel(
      id: id,
      title: title,
      price: price,
      sellerName: sellerName,
      sellerAvatarUrl: sellerAvatarUrl,
      location: location,
      createdAt: createdAt,
      condition: condition,
      status: status,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// 670000 -> "Rp 670.000"
  String get priceLabel {
    final digits = price.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => '.',
        );
    return 'Rp $digits';
  }

  /// "2 jam lalu", "5 menit lalu", "3 hari lalu"
  String get postedAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }
}
