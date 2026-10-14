import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

/// Widget Galeri Foto Produk dengan 3 thumbnail vertikal melayang di sisi kiri.
class ProductGallery extends StatelessWidget {
  const ProductGallery({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onSelectIndex,
    required this.height,
  });

  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;
  final double height;

  @override
  Widget build(BuildContext context) {
    final activeUrl = images.isNotEmpty ? images[selectedIndex] : '';

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.circular(16),
        image: activeUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(activeUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          // 3 Thumbnail vertikal di sisi kiri gambar utama (sesuai mockup)
          Positioned(
            left: 16,
            bottom: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(images.length, (index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GestureDetector(
                    onTap: () => onSelectIndex(index),
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Color(0xFFE0E0E0), width: 2.5)
                            : Border.all(
                                color: AppColors.surfaceElevated, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neutral900.withValues(
                              alpha: 0.26,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
