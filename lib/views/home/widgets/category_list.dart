import 'package:flutter/material.dart';

import '../../../../models/CategoryModel.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.neutral200,
              backgroundImage: category.iconUrl != null
                  ? NetworkImage(category.iconUrl!)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              textAlign: TextAlign.center,
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
