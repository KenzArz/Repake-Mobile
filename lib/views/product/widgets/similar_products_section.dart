import 'package:flutter/material.dart';

import '../../../models/ProductModel.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'product_card.dart';
import '../../../widgets/wireframe_overlay.dart';

/// Bagian Rekomendasi "Produk yang Mirip" yang responsif (Row untuk Desktop, Horizontal scroll untuk Mobile).
class SimilarProductsSection extends StatelessWidget {
  const SimilarProductsSection({
    super.key,
    required this.similarProducts,
    required this.isWide,
    required this.onProductTap,
    required this.onFavoriteTap,
    required this.onReportTap,
  });

  final List<ProductModel> similarProducts;
  final bool isWide;
  final ValueChanged<ProductModel> onProductTap;
  final ValueChanged<ProductModel> onFavoriteTap;
  final VoidCallback onReportTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WText(
          'Produk yang Mirip',
          style: AppTextStyles.h4().copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 16),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < similarProducts.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(
                  child: ProductCard(
                    product: similarProducts[i],
                    onTap: () => onProductTap(similarProducts[i]),
                    onFavoriteTap: () => onFavoriteTap(similarProducts[i]),
                    onMoreTap: onReportTap,
                  ),
                ),
              ],
            ],
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < similarProducts.length; i++) ...[
                  if (i > 0) const SizedBox(width: 14),
                  SizedBox(
                    width: 210,
                    child: ProductCard(
                      product: similarProducts[i],
                      onTap: () => onProductTap(similarProducts[i]),
                      onFavoriteTap: () => onFavoriteTap(similarProducts[i]),
                      onMoreTap: onReportTap,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
