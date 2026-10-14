import 'package:flutter/material.dart';

import '../../../models/MessageModel.dart';
import '../../../models/OfferModel.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Bubble untuk pesan tipe offer (penawaran harga).
/// Tampilan berbeda untuk pembeli vs penjual, dan berbeda per status.
class OfferBubble extends StatelessWidget {
  const OfferBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isSeller,
    this.onEdit,
    this.onCancel,
  });

  final MessageModel message;
  final bool isMe;
  final bool isSeller; // apakah current user = penjual dalam chat ini
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final offer = message.offerData!;
    final status = offer.status;

    // Jika offer accepted/rejected, tampilkan sebagai system message di tengah
    if (status == OfferStatus.accepted || status == OfferStatus.rejected) {
      return _buildSystemMessage(offer);
    }

    // Jika offer pending dari seller, tampilkan bubble dari pembeli
    if (isSeller && status == OfferStatus.pending) {
      return _buildSellerPendingView(offer);
    }

    // Jika current user = pembeli dengan offer pending
    if (!isSeller) {
      return _buildBuyerView(offer);
    }

    // Fallback
    return const SizedBox.shrink();
  }

  /// View untuk penjual saat offer masih pending.
  Widget _buildSellerPendingView(OfferModel offer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8, top: 4),
            decoration: BoxDecoration(
              color: AppColors.neutral300,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderDefault, width: 0.5),
            ),
            child: const Icon(
              Icons.person,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),

          // Bubble dengan background transparan/border
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.neutral300, width: 1.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Menawar',
                  style: AppTextStyles.caption().copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer.priceLabel,
                  style: AppTextStyles.h5().copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// View untuk pembeli (semua status).
  Widget _buildBuyerView(OfferModel offer) {
    final status = offer.status;
    Color bgColor;
    Color textColor;
    String statusLabel;
    IconData? statusIcon;

    switch (status) {
      case OfferStatus.pending:
        bgColor = const Color(0xFF9E9E9E);
        textColor = AppColors.charcoal;
        statusLabel = 'Menawar';
        statusIcon = null;
        break;
      case OfferStatus.accepted:
        bgColor = AppColors.successBase;
        textColor = AppColors.textOnDark;
        statusLabel = 'Penawaran Disetujui';
        statusIcon = Icons.check_circle;
        break;
      case OfferStatus.rejected:
        bgColor = AppColors.errorBase;
        textColor = AppColors.textOnDark;
        statusLabel = 'Penawaran Ditolak';
        statusIcon = Icons.cancel;
        break;
    }

    final showActions = status == OfferStatus.pending;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Status + icon
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (statusIcon != null) ...[
                          Icon(statusIcon, size: 16, color: textColor),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          statusLabel,
                          style: AppTextStyles.caption().copyWith(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Harga
                    Text(
                      offer.priceLabel,
                      style: AppTextStyles.h5().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),

                    // Tombol Edit & Batalkan (jika pending)
                    if (showActions && (onEdit != null || onCancel != null)) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onEdit != null)
                            OutlinedButton(
                              onPressed: onEdit,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(60, 32),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                side: const BorderSide(
                                    color: AppColors.charcoal, width: 1.5),
                                backgroundColor: Colors.transparent, // Transparan
                                foregroundColor: AppColors.charcoal,
                                overlayColor: AppColors.charcoal.withValues(alpha: 0.1), // Animasi click
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Edit',
                                style: AppTextStyles.caption().copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.charcoal,
                                ),
                              ),
                            ),
                          if (onEdit != null && onCancel != null)
                            const SizedBox(width: 8),
                          if (onCancel != null)
                            FilledButton(
                              onPressed: onCancel,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(60, 32),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                backgroundColor: AppColors.errorBase,
                                foregroundColor: AppColors.textOnDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Batalkan',
                                style: AppTextStyles.caption().copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textOnDark,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// System message di tengah untuk offer accepted/rejected.
  Widget _buildSystemMessage(OfferModel offer) {
    final isAccepted = offer.status == OfferStatus.accepted;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16), // Samakan dengan chat bubble biasa
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isAccepted 
                ? AppColors.successTint 
                : AppColors.errorTint,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isAccepted 
                  ? AppColors.successBase 
                  : AppColors.errorBase,
            ),
          ),
          child: Text(
            isAccepted 
                ? 'Penawaran disetujui' 
                : 'Penawaran ditolak',
            style: AppTextStyles.caption().copyWith(
              fontWeight: FontWeight.w600,
              color: isAccepted 
                  ? AppColors.successShade 
                  : AppColors.errorShade,
            ),
          ),
        ),
      ),
    );
  }
}
