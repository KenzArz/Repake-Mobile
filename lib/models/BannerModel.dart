/// Banner yang tampil di slider beranda.
class BannerModel {
  const BannerModel({
    required this.id,
    required this.title,
    this.imagePath,
    this.isActive = true,
  });

  final String id;

  /// Judul hanya untuk admin (penanda), tidak tampil ke pengguna.
  final String title;

  /// Lokasi gambar: bisa path file lokal (hasil pilih galeri) atau URL
  /// (https://...). null = belum ada gambar.
  final String? imagePath;

  /// true = tampil di beranda, false = disembunyikan.
  final bool isActive;

  BannerModel copyWith({String? title, String? imagePath, bool? isActive}) {
    return BannerModel(
      id: id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
    );
  }
}