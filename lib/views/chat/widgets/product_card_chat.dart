import 'package:flutter/material.dart';

import '../../../models/ChatModel.dart';
import '../../../models/OfferModel.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Product card yang muncul di atas chat room saat ada offer aktif.
/// Menampilkan info produk + status offer + tombol aksi (untuk penjual).
class ProductCardChat extends StatelessWidget {
  const ProductCardChat({
    super.key,
    required this.chat,
    required this.offer,
    required this.currentUserId,
    this.onTap,
    this.onAccept,
    this.onReject,
  });

  final ChatModel chat;
  final OfferModel? offer;
  final String currentUserId;
  final VoidCallback? onTap;
  final VoidCallback? onAccept; // hanya untuk penjual
  final VoidCallback? onReject; // hanya untuk penjual

  @override
  Widget build(BuildContext context) {
    if (offer == null) return const SizedBox.shrink();

    final product = chat.product;
    final isSeller = chat.isSeller(currentUserId);
    final status = offer!.status;

    // Warna badge berdasarkan status
    Color badgeColor;
    String badgeLabel;

    switch (status) {
      case OfferStatus.pending:
        badgeColor = AppColors.warningBase;
        badgeLabel = 'Ditawar';
        break;
      case OfferStatus.accepted:
        badgeColor = AppColors.successBase;
        badgeLabel = 'Disetujui';
        break;
      case OfferStatus.rejected:
        badgeColor = AppColors.errorBase;
        badgeLabel = 'Ditolak';
        break;
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(
          bottom: BorderSide(color: AppColors.borderDefault),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Product info
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderDefault),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 56,
                      height: 56,
                      color: AppColors.neutral200,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 28,
                        color: AppColors.neutral400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Product details - gunakan Flexible dengan flex kecil
                  Flexible(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.priceLabel,
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.textSecondary,
                            decoration: status == OfferStatus.accepted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Badge + offer price - gunakan Flexible dengan flex lebih besar
                  Flexible(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badgeLabel,
                            style: AppTextStyles.caption().copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textOnDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Offer price
                        Text(
                          offer!.priceLabel,
                          style: AppTextStyles.label().copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons (hanya untuk penjual dengan offer pending)
          if (isSeller &&
              status == OfferStatus.pending &&
              (onAccept != null || onReject != null)) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (onReject != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        side: const BorderSide(color: AppColors.errorBase),
                        foregroundColor: AppColors.errorBase,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Tolak',
                        style: AppTextStyles.label().copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (onAccept != null && onReject != null)
                  const SizedBox(width: 12),
                if (onAccept != null)
                  Expanded(
                    child: FilledButton(
                      onPressed: onAccept,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        backgroundColor: Color(0xFFE0E0E0),
                        foregroundColor: AppColors.charcoal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Terima',
                        style: AppTextStyles.label().copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
