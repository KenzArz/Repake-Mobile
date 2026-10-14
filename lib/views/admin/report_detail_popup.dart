import 'package:flutter/material.dart';

import '../../models/ReportModel.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/report_type_chip.dart';
import '../../widgets/wireframe_overlay.dart';

/// Menampilkan detail report sebagai pop up dari bawah (bottom sheet).
///
/// Cara pakai:
///   showReportDetailPopup(context, report);
Future<void> showReportDetailPopup(BuildContext context, ReportModel report) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true, // boleh tinggi sampai hampir penuh layar
    useSafeArea: true, // jangan menimpa status bar
    backgroundColor: AppColors.surfacePage,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ReportDetailSheet(report: report),
  );
}

class _ReportDetailSheet extends StatelessWidget {
  const _ReportDetailSheet({required this.report});

  final ReportModel report;

  // Nama bulan untuk format tanggal (tanpa paket intl).
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  /// 12 Okt 2026, 14:30
  String _formatDate(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${_months[d.month - 1]} ${d.year}, $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final product = report.product;

    // DraggableScrollableSheet = sheet yang bisa ditarik naik/turun,
    // dan isinya bisa di-scroll.
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // Garis kecil di atas (tanda bisa ditarik)
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Judul + tombol tutup
            Row(
              children: [
                Expanded(child: WText('Detail Report', style: AppTextStyles.h4())),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const WIcon(Icons.close),
                  tooltip: 'Tutup',
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Gambar produk
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: product.imageUrl == null
                    ? Container(
                        color: AppColors.neutral200,
                        child: const WIcon(Icons.image_outlined,
                            size: 40, color: AppColors.neutral400),
                      )
                    : WImage.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.neutral200),
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Nama & harga produk
            WText(product.title, style: AppTextStyles.h4()),
            const SizedBox(height: 2),
            WText(
              product.priceLabel,
              style: AppTextStyles.h5()
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // Kartu info (Penjual, Pelapor, Jenis, Tanggal, Lokasi)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Column(
                children: [
                  _InfoRow(label: 'Penjual', child: _value(product.sellerName)),
                  const _RowDivider(),
                  _InfoRow(label: 'Pelapor', child: _value(report.reporterName)),
                  const _RowDivider(),
                  _InfoRow(
                    label: 'Jenis Report',
                    child: ReportTypeChip(type: report.type),
                  ),
                  const _RowDivider(),
                  _InfoRow(
                    label: 'Tanggal',
                    child: _value(_formatDate(report.createdAt)),
                  ),
                  const _RowDivider(),
                  _InfoRow(label: 'Lokasi Barang', child: _value(product.location)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Keterangan dari pelapor
            WText(
              'Keterangan Pelapor',
              style: AppTextStyles.h5().copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: WText(
                report.description.isEmpty
                    ? 'Pelapor tidak menambahkan keterangan.'
                    : report.description,
                style: AppTextStyles.body(),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol aksi.
            // Admin hanya melihat laporan, jadi tidak ada tombol hapus/ubah.
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: buka halaman detail produk (product_detail.dart)
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      foregroundColor: AppColors.charcoal,
                      side: const BorderSide(color: AppColors.charcoal),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const WText('Lihat Produk'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Color(0xFFE0E0E0),
                      foregroundColor: AppColors.charcoal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const WText('Tutup'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Teks nilai standar untuk baris info.
  Widget _value(String text) => WText(
        text,
        textAlign: TextAlign.right,
        style: AppTextStyles.label().copyWith(fontWeight: FontWeight.w600),
      );
}

/// Satu baris info: label di kiri, nilai di kanan.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          WText(
            label,
            style: AppTextStyles.label()
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: child),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: AppColors.borderDefault);
}