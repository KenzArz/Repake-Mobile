import 'package:flutter/material.dart';

import '../../../models/ProductModel.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../profile/seller_profile.dart';

/// Bagian detail info produk: Seller Info, Judul, Harga, Tag status, Deskripsi,
/// tombol Chat Penjual, dan form Tawar Harga.
class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({
    super.key,
    required this.product,
    required this.offerController,
    required this.onChatTap,
    required this.onSubmitOffer,
    required this.onReportTap,
  });

  final ProductModel product;
  final TextEditingController offerController;
  final VoidCallback onChatTap;
  final VoidCallback onSubmitOffer;
  final VoidCallback onReportTap;

  static const Color repakeLime = Color(0xFFC3E06D);
  static const Color repakeChipBg = Color(0xFFE8EAE6);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baris Info Penjual (Foto, Nama, Rating bintang kuning 4.5, Lokasi, Titik 3)
        _buildSellerInfoRow(context),

        const SizedBox(height: 14),

        // Judul Produk
        Text(
          product.title,
          style: AppTextStyles.h4().copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.charcoal,
            height: 1.25,
          ),
        ),

        const SizedBox(height: 10),

        // Harga Produk (Rp 670.000)
        Text(
          product.priceLabel,
          style: AppTextStyles.h3().copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.charcoal,
          ),
        ),

        const SizedBox(height: 14),

        // Baris 3 Tag: "Dijual" (hijau lime), "Dirawat dengan baik", "Elektronik"
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildStatusChip('Dijual', isGreen: true),
            _buildStatusChip('Dirawat dengan baik', isGreen: false),
            _buildStatusChip('Elektronik', isGreen: false),
          ],
        ),

        const SizedBox(height: 20),

        // Judul Deskripsi
        Text(
          'Deskripsi',
          style: AppTextStyles.h5().copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.charcoal,
          ),
        ),

        const SizedBox(height: 8),

        // Isi Paragraf Deskripsi
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent auctor purus luctus enim egestas, ac scelerisque ante pulvinar. Donec ut rhoncus ex. Suspendisse ac rhoncus nisl, eu tempor urna. Curabitur vel bibendum lorem. Morbi convallis convallis diam sit amet lacinia. Aliquam in elementum tellus.',
          style: AppTextStyles.body().copyWith(
            fontSize: 13,
            color: AppColors.neutral700,
            height: 1.55,
          ),
        ),

        const SizedBox(height: 24),

        // Tombol Lebar Penuh: "Chat Penjual"
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: repakeLime,
              foregroundColor: AppColors.charcoal,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onChatTap,
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 18,
              color: AppColors.charcoal,
            ),
            label: Text(
              'Chat Penjual',
              style: AppTextStyles.label().copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
                fontSize: 14.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Baris Input Penawaran Harga & Tombol "Tawar Harga"
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: TextField(
                  controller: offerController,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.body().copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                  decoration: InputDecoration(
                    prefixText: 'Rp. ',
                    prefixStyle: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                      fontSize: 13.5,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.neutral300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.neutral300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.charcoal),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: repakeLime,
                  foregroundColor: AppColors.charcoal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                onPressed: onSubmitOffer,
                child: Text(
                  'Tawar Harga',
                  style: AppTextStyles.label().copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSellerInfoRow(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SellerProfilePage(
                  sellerName: product.sellerName,
                  location: product.location,
                  rating: 4.5,
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: AppColors.neutral200,
                backgroundImage: product.sellerAvatarUrl != null
                    ? NetworkImage(product.sellerAvatarUrl!)
                    : null,
                child: product.sellerAvatarUrl == null
                    ? const Icon(Icons.person, color: Colors.white, size: 22)
                    : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        product.sellerName,
                        style: AppTextStyles.label().copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFC107),
                        size: 16,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '4.5',
                        style: AppTextStyles.label().copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${product.location} · ${product.postedAgo}',
                    style: AppTextStyles.caption().copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: onReportTap,
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, {required bool isGreen}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isGreen ? repakeLime : repakeChipBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption().copyWith(
          fontWeight: isGreen ? FontWeight.w800 : FontWeight.w600,
          fontSize: 12,
          color: AppColors.charcoal,
        ),
      ),
    );
  }
}
