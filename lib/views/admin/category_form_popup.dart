import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/wireframe_overlay.dart';

/// Popup form untuk tambah atau edit kategori.
/// Muncul dari bawah dengan animasi slide up.
void showCategoryFormPopup(
  BuildContext context, {
  required String title,
  String? initialName,
  required void Function(String name) onSave,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _CategoryFormPopup(
      title: title,
      initialName: initialName,
      onSave: onSave,
    ),
  );
}

class _CategoryFormPopup extends StatefulWidget {
  const _CategoryFormPopup({
    required this.title,
    this.initialName,
    required this.onSave,
  });

  final String title;
  final String? initialName;
  final void Function(String name) onSave;

  @override
  State<_CategoryFormPopup> createState() => _CategoryFormPopupState();
}

class _CategoryFormPopupState extends State<_CategoryFormPopup> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(_nameController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: WText(widget.title, style: AppTextStyles.h5()),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const WIcon(Icons.close),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Input Nama Kategori
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  hintText: 'Masukkan nama kategori',
                  prefixIcon: const WIcon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.neutral300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.neutral300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.charcoal,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.errorBase),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.errorBase,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceElevated,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: AppTextStyles.body(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kategori tidak boleh kosong';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama kategori minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE0E0E0),
                  foregroundColor: AppColors.charcoal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: AppTextStyles.label().copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                child: const WText('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
