import 'ProductModel.dart';

/// Jenis laporan yang bisa dipilih pelapor.
/// TODO: samakan dengan pilihan di tombol Report pada halaman detail produk.
enum ReportType {
  fraud('Penipuan'),
  prohibited('Barang Terlarang'),
  misleading('Menyesatkan'),
  spam('Spam'),
  other('Lainnya');

  const ReportType(this.label);

  /// Teks yang ditampilkan di UI.
  final String label;
}

/// Satu laporan terhadap sebuah produk.
class ReportModel {
  const ReportModel({
    required this.id,
    required this.product,
    required this.reporterName,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  final String id;

  /// Produk yang dilaporkan (nama, gambar, penjual diambil dari sini).
  final ProductModel product;

  /// Nama pengguna yang melapor.
  final String reporterName;

  final ReportType type;

  /// Keterangan tambahan dari pelapor.
  final String description;

  final DateTime createdAt;
}
