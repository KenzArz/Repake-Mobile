import 'package:flutter/material.dart';

import '../../models/ProductModel.dart';
import '../../models/ReportModel.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'report_detail_popup.dart';
import 'widgets/report_type_chip.dart';

/// Tab "Laporan": tabel report (No, Gambar, Nama, Penjual, Jenis Report).
/// Baris ditekan -> muncul detail report (pop up dari bawah).
/// Admin hanya MELIHAT laporan (tanpa tambah / ubah / hapus).
class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

// AutomaticKeepAliveClientMixin = tab ini tidak "dibuang" saat pindah tab,
// jadi posisi scroll-nya tetap tersimpan.
class _ReportListScreenState extends State<ReportListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // TODO: ganti dengan data dari admin_controller (database).
  late final List<ReportModel> _reports = _dummyReports();

  static List<ReportModel> _dummyReports() {
    const types = ReportType.values;
    return List.generate(8, (i) {
      return ReportModel(
        id: 'r$i',
        product: ProductModel(
          id: 'p$i',
          title: 'Femboy imup ganas ${i + 1}',
          price: 670000,
          sellerName: 'Midou_kun',
          location: 'Bekasi',
          createdAt: DateTime.now().subtract(Duration(days: i)),
          condition: 'Dirawat dengan baik',
        ),
        reporterName: 'Mahasiswa_${i + 1}',
        type: types[i % types.length],
        description:
            'Barang tidak sesuai dengan foto dan penjual meminta pembayaran '
            'di luar aplikasi.',
        createdAt: DateTime.now().subtract(Duration(hours: i * 5 + 1)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // wajib dipanggil karena memakai KeepAlive

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul + jumlah laporan
          Row(
            children: [
              Expanded(child: Text('Daftar Report', style: AppTextStyles.h5())),
              Text(
                '${_reports.length} laporan',
                style: AppTextStyles.caption()
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tabel (mengisi sisa tinggi layar, isinya bisa di-scroll)
          Expanded(
            child: _ReportTable(
              reports: _reports,
              onTapRow: (report) => showReportDetailPopup(context, report),
            ),
          ),
        ],
      ),
    );
  }
}

// Lebar kolom tetap. Header dan baris memakai angka yang sama supaya sejajar.
// Kolom Nama / Penjual / Jenis membagi sisa lebar (flex 3 : 2 : 2).
const double _colNo = 28;
const double _colImage = 44;
const double _colGap = 8;

class _ReportTable extends StatelessWidget {
  const _ReportTable({required this.reports, required this.onTapRow});

  final List<ReportModel> reports;
  final ValueChanged<ReportModel> onTapRow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      clipBehavior: Clip.antiAlias, // potong isi mengikuti sudut membulat
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          const _HeaderRow(),
          const Divider(height: 1, color: AppColors.borderDefault),
          Expanded(
            child: reports.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada laporan.',
                      style: AppTextStyles.body()
                          .copyWith(color: AppColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    itemCount: reports.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AppColors.borderDefault,
                    ),
                    itemBuilder: (context, i) => _ReportRow(
                      number: i + 1, // kolom "No"
                      report: reports[i],
                      onTap: () => onTapRow(reports[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Baris judul kolom.
class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.caption().copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
    );

    return Container(
      color: AppColors.neutral100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(width: _colNo, child: Text('No', style: style)),
          const SizedBox(width: _colGap),
          SizedBox(width: _colImage, child: Text('Gambar', style: style)),
          const SizedBox(width: _colGap),
          Expanded(flex: 3, child: Text('Nama', style: style)),
          const SizedBox(width: _colGap),
          Expanded(flex: 2, child: Text('Penjual', style: style)),
          const SizedBox(width: _colGap),
          Expanded(
            flex: 2,
            child: Text('Jenis', style: style, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

/// Satu baris data report.
class _ReportRow extends StatelessWidget {
  const _ReportRow({
    required this.number,
    required this.report,
    required this.onTap,
  });

  final int number;
  final ReportModel report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final product = report.product;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // No
            SizedBox(
              width: _colNo,
              child: Text('$number', style: AppTextStyles.caption()),
            ),
            const SizedBox(width: _colGap),

            // Gambar produk
            SizedBox(
              width: _colImage,
              height: _colImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _Thumb(url: product.imageUrl),
              ),
            ),
            const SizedBox(width: _colGap),

            // Nama produk (maksimal 2 baris)
            Expanded(
              flex: 3,
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label()
                    .copyWith(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: _colGap),

            // Penjual
            Expanded(
              flex: 2,
              child: Text(
                product.sellerName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption(),
              ),
            ),
            const SizedBox(width: _colGap),

            // Jenis report
            Expanded(
              flex: 2,
              child: Center(
                child: ReportTypeChip(type: report.type, compact: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gambar kecil produk; kalau belum ada gambar tampil kotak abu-abu.
class _Thumb extends StatelessWidget {
  const _Thumb({this.url});

  final String? url;

  Widget _placeholder() => Container(
        color: AppColors.neutral200,
        child: const Icon(Icons.image_outlined,
            size: 20, color: AppColors.neutral400),
      );

  @override
  Widget build(BuildContext context) {
    if (url == null) return _placeholder();
    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}
