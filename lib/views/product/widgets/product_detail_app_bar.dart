import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/wireframe_overlay.dart';

/// App Bar tetap (Sticky) untuk Halaman Detail Produk.
/// Menampilkan tombol kembali, brand "RePake", dan ikon favorit (wishlist).
class ProductDetailAppBar extends StatelessWidget {
  const ProductDetailAppBar({
    super.key,
    required this.isWide,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.title = 'RePake',
  });

  final bool isWide;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfacePage,
        border: const Border(
          bottom: BorderSide(color: AppColors.neutral200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 32 : 12,
        vertical: 8,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              // Tombol Kembali
              IconButton(
                icon: const WIcon(Icons.arrow_back, color: AppColors.charcoal),
                tooltip: 'Kembali',
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),

              const SizedBox(width: 4),

              // Judul / Brand ("RePake")
              WText(
                title,
                style: AppTextStyles.h4().copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.charcoal,
                  fontSize: isWide ? 20 : 18,
                ),
              ),

              const Spacer(),

              // Ikon Wishlist / Favorit
              IconButton(
                icon: WIcon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Color(0xFFE0E0E0) : AppColors.charcoal,
                  size: 22,
                ),
                tooltip: 'Favorit',
                onPressed: onFavoriteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
