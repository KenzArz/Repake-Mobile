import 'package:flutter/material.dart';

import '../../models/CategoryModel.dart';
import '../../models/DummyData.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'category_form_popup.dart';

/// Tab "Kategori": tabel kategori dengan fitur CRUD
/// (Create, Read, Update, Delete).
/// Admin bisa menambah, mengedit, menghapus, dan melihat tabel kategori.
class CategoryManageScreen extends StatefulWidget {
  const CategoryManageScreen({super.key});

  @override
  State<CategoryManageScreen> createState() => _CategoryManageScreenState();
}

class _CategoryManageScreenState extends State<CategoryManageScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Gunakan data dari DummyData (no more hardcoded!)
  final List<CategoryModel> _categories = List.from(DummyData.categories);

  void _showAddCategoryDialog() {
    showCategoryFormPopup(
      context,
      title: 'Tambah Kategori',
      onSave: (name) {
        setState(() {
          _categories.add(
            CategoryModel(
              id: 'c${_categories.length + 1}',
              name: name,
            ),
          );
        });
      },
    );
  }

  void _showEditCategoryDialog(CategoryModel category, int index) {
    showCategoryFormPopup(
      context,
      title: 'Edit Kategori',
      initialName: category.name,
      onSave: (name) {
        setState(() {
          _categories[index] = CategoryModel(
            id: category.id,
            name: name,
            iconUrl: category.iconUrl,
          );
        });
      },
    );
  }

  void _showDeleteConfirmDialog(CategoryModel category, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Kategori', style: AppTextStyles.h5()),
        content: Text(
          'Apakah Anda yakin ingin menghapus kategori "${category.name}"?',
          style: AppTextStyles.body(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppTextStyles.label().copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _categories.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text(
              'Hapus',
              style: AppTextStyles.label().copyWith(
                color: AppColors.errorBase,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Judul + Tombol Tambah
          Row(
            children: [
              Expanded(
                child: Text('Daftar Kategori', style: AppTextStyles.h5()),
              ),
              Text(
                '${_categories.length} kategori',
                style: AppTextStyles.caption()
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              // Tombol Tambah Kategori
              ElevatedButton.icon(
                onPressed: _showAddCategoryDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lime,
                  foregroundColor: AppColors.charcoal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  textStyle: AppTextStyles.label().copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tabel Kategori
          Expanded(
            child: _CategoryTable(
              categories: _categories,
              onEdit: _showEditCategoryDialog,
              onDelete: _showDeleteConfirmDialog,
            ),
          ),
        ],
      ),
    );
  }
}

// Lebar kolom tetap
const double _colNo = 50;
const double _colIcon = 50;
const double _colGap = 12;
const double _colActions = 120;

class _CategoryTable extends StatelessWidget {
  const _CategoryTable({
    required this.categories,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CategoryModel> categories;
  final void Function(CategoryModel category, int index) onEdit;
  final void Function(CategoryModel category, int index) onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          const _HeaderRow(),
          const Divider(height: 1, color: AppColors.borderDefault),
          Expanded(
            child: categories.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada kategori.',
                      style: AppTextStyles.body()
                          .copyWith(color: AppColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AppColors.borderDefault,
                    ),
                    itemBuilder: (context, i) => _CategoryRow(
                      number: i + 1,
                      category: categories[i],
                      onEdit: () => onEdit(categories[i], i),
                      onDelete: () => onDelete(categories[i], i),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Baris header tabel
class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.caption().copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
    );

    return Container(
      color: AppColors.neutral100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(width: _colNo, child: Text('No', style: style)),
          const SizedBox(width: _colGap),
          SizedBox(width: _colIcon, child: Text('Icon', style: style)),
          const SizedBox(width: _colGap),
          Expanded(child: Text('Nama Kategori', style: style)),
          const SizedBox(width: _colGap),
          SizedBox(
            width: _colActions,
            child: Text('Aksi', style: style, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

/// Satu baris data kategori
class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.number,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  final int number;
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // No
          SizedBox(
            width: _colNo,
            child: Text(
              '$number',
              style: AppTextStyles.caption().copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: _colGap),

          // Icon Category
          SizedBox(
            width: _colIcon,
            height: _colIcon,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _CategoryIcon(iconUrl: category.iconUrl),
            ),
          ),
          const SizedBox(width: _colGap),

          // Nama Kategori
          Expanded(
            child: Text(
              category.name,
              style: AppTextStyles.label().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: _colGap),

          // Tombol Aksi (Edit & Hapus)
          SizedBox(
            width: _colActions,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Edit
                _ActionButton(
                  icon: Icons.edit_outlined,
                  color: AppColors.lime700,
                  onTap: onEdit,
                  tooltip: 'Edit',
                ),
                const SizedBox(width: 8),
                // Tombol Hapus
                _ActionButton(
                  icon: Icons.delete_outline,
                  color: AppColors.errorBase,
                  onTap: onDelete,
                  tooltip: 'Hapus',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon kategori kecil
class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({this.iconUrl});

  final String? iconUrl;

  Widget _placeholder() => Container(
        color: AppColors.neutral200,
        child: const Icon(
          Icons.category_outlined,
          size: 24,
          color: AppColors.neutral400,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (iconUrl == null || iconUrl!.isEmpty) return _placeholder();

    return Image.network(
      iconUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.neutral200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral400),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}

/// Tombol aksi kecil (Edit/Hapus)
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
