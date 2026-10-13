import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/ChatModel.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Bottom sheet untuk membuat penawaran harga (pembeli).
/// Muncul saat user klik icon dollar / tawar harga.
class OfferActionSheet extends StatefulWidget {
  const OfferActionSheet({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onOfferSubmit,
  });

  final ChatModel chat;
  final String currentUserId;
  final ValueChanged<int> onOfferSubmit; // callback dengan harga yang ditawar

  @override
  State<OfferActionSheet> createState() => _OfferActionSheetState();
}

class _OfferActionSheetState extends State<OfferActionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final price = int.parse(_priceController.text);
    widget.onOfferSubmit(price);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.chat.product;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfacePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
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
          const SizedBox(height: 16),

          // Title
          Text('Tawar Harga', style: AppTextStyles.h4()),
          const SizedBox(height: 16),

          // Product info (mini card)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              border: Border.all(color: AppColors.borderDefault),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 48,
                    height: 48,
                    color: AppColors.neutral200,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 24,
                      color: AppColors.neutral400,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Harga awal: ${product.priceLabel}',
                        style: AppTextStyles.caption().copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Form input harga
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harga Tawaran',
                  style: AppTextStyles.label().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofocus: true,
                  style: AppTextStyles.body(),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.surfaceElevated,
                    hintText: 'Masukkan harga tawaran...',
                    hintStyle: AppTextStyles.body()
                        .copyWith(color: AppColors.textMuted),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: Text(
                        'Rp',
                        style: AppTextStyles.label().copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppColors.borderDefault),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.charcoal),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.errorBase),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.errorBase),
                    ),
                  ),
                  validator: (v) {
                    final price = int.tryParse(v ?? '');
                    if (price == null || price <= 0) {
                      return 'Harga harus diisi dengan angka valid';
                    }
                    if (price >= product.price) {
                      return 'Harga tawaran harus lebih kecil dari harga awal';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: AppColors.charcoal,
                    side: const BorderSide(color: AppColors.charcoal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.lime,
                    foregroundColor: AppColors.charcoal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Kirim Tawaran'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
