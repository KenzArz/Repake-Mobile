import 'package:flutter/material.dart';

import '../../../models/ReportModel.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Label kecil berwarna untuk jenis report (Penipuan, Spam, dst).
/// [compact] = ukuran lebih kecil, dipakai di dalam tabel.
class ReportTypeChip extends StatelessWidget {
  const ReportTypeChip({super.key, required this.type, this.compact = false});

  final ReportType type;
  final bool compact;

  // Warna latar & teks per jenis report. Ubah di sini kalau ingin ganti warna.
  (Color bg, Color fg) get _colors {
    switch (type) {
      case ReportType.fraud:
      case ReportType.prohibited:
        return (AppColors.errorTint, AppColors.errorShade);
      case ReportType.misleading:
        return (AppColors.warningTint, AppColors.warningShade);
      case ReportType.spam:
        return (AppColors.infoTint, AppColors.infoShade);
      case ReportType.other:
        return (AppColors.neutral100, AppColors.neutral700);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(compact ? 8 : 999),
      ),
      child: Text(
        type.label,
        textAlign: TextAlign.center,
        maxLines: compact ? 2 : 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption().copyWith(
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
