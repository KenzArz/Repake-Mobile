import 'package:flutter/material.dart';

import '../../../../models/CategoryModel.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/wireframe_overlay.dart';

/// Baris kategori yang bisa di-scroll ke samping (lingkaran + label).
class CategoryList extends StatelessWidget {
  const CategoryList({super.key, required this.categories, this.onTap});

  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel>? onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < categories.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            _CategoryItem(
              category: categories[i],
              onTap: onTap == null ? null : () => onTap!(categories[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category, this.onTap});

  final CategoryModel category;
  final VoidCallback? onTap;

  // Helper untuk mendapatkan icon berdasarkan nama kategori
  IconData _getCategoryIcon() {
    final name = category.name.toLowerCase();
    if (name.contains('elektronik')) return Icons.devices_rounded;
    if (name.contains('pakaian')) return Icons.checkroom_rounded;
    if (name.contains('perabot') || name.contains('furniture'))
      return Icons.chair_rounded;
    if (name.contains('olahraga') || name.contains('sport'))
      return Icons.sports_soccer_rounded;
    if (name.contains('buku') || name.contains('book'))
      return Icons.menu_book_rounded;
    return Icons.category_rounded; // Default untuk "Lainnya" atau lainnya
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            WAvatar(
              radius: 32,
              backgroundImage: category.iconUrl != null
                  ? NetworkImage(category.iconUrl!)
                  : null,
              child: category.iconUrl == null
                  ? WIcon(_getCategoryIcon(), size: 32)
                  : null,
            ),
            const SizedBox(height: 8),
            WText(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label(),
            ),
          ],
        ),
      ),
    );
  }
}
