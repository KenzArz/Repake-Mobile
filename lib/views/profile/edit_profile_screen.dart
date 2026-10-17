import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/ProfileController.dart';
import '../../models/UserModel.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Halaman Form Edit Profil Pengguna (MVC Architecture - View Layer).
///
/// Memungkinkan pengguna mengubah foto profil (dari kamera/galeri), nama lengkap,
/// email, nomor telepon/WhatsApp, lokasi, dan bio/deskripsi toko.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.user,
    this.controller,
  });

  /// Data user awal yang ingin diedit. Jika null, controller akan menggunakan default user.
  final UserModel? user;

  /// Custom ProfileController jika ingin diinjeksi dari luar
  final ProfileController? controller;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final ProfileController _controller;
  late final bool _isLocalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isLocalController = false;
      if (widget.user != null) {
        _controller.updateUser(widget.user!);
      }
    } else {
      _controller = ProfileController.instance;
      _isLocalController = false;
      if (widget.user != null) {
        _controller.updateUser(widget.user!);
      } else {
        _controller.syncControllersWithUser();
      }
    }
  }

  @override
  void dispose() {
    if (_isLocalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // ACTIONS / HANDLERS
  // ---------------------------------------------------------------------------

  Future<void> _handleSave() async {
    final result = await _controller.saveProfile();

    if (!mounted) return;

    if (result == null ||
        result.contains('tidak') ||
        result.contains('gagal')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? 'Terjadi kesalahan saat menyimpan data'),
          backgroundColor: AppColors.errorBase,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );

    // Kembali ke halaman sebelumnya dan kirim data user terbaru
    Navigator.pop(context, _controller.currentUser);
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Foto Profil',
                      style: AppTextStyles.h4().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.charcoal,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const Divider(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lime.withAlpha(80),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_camera_rounded,
                      color: AppColors.charcoal,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Ambil Foto (Kamera)',
                    style: AppTextStyles.label().copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _controller.pickAvatar(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lime.withAlpha(80),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: AppColors.charcoal,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Pilih dari Galeri',
                    style: AppTextStyles.label().copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _controller.pickAvatar(ImageSource.gallery);
                  },
                ),
                if (_controller.avatarFile != null ||
                    _controller.currentAvatarUrl != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.errorTint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.errorBase,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      'Hapus Foto Profil',
                      style: AppTextStyles.label().copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.errorBase,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _controller.removeAvatar();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD METHOD (PRESENTATION)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfacePage,
      appBar: AppBar(
        backgroundColor: AppColors.surfacePage,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.charcoal),
          tooltip: 'Kembali',
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profil',
          style: AppTextStyles.h4().copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.charcoal,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _controller.isLoading ? null : _handleSave,
              child: Text(
                'Simpan',
                style: AppTextStyles.label().copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.charcoal,
                  fontSize: 14.5,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.neutral200,
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Column(
                children: [
                  // 1. Avatar Picker Section
                  _buildAvatarSection(),

                  const SizedBox(height: 28),

                  // 2. Form Input Fields Card
                  _buildFormCard(),

                  const SizedBox(height: 32),

                  // 3. Tombol Simpan Perubahan Utama
                  _buildSaveButton(),

                  const SizedBox(height: 12),

                  // 4. Tombol Keluar dari Akun
                  _buildLogoutButton(),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    ImageProvider? imageProvider;
    if (_controller.avatarFile != null) {
      if (kIsWeb) {
        imageProvider = NetworkImage(_controller.avatarFile!.path);
      } else {
        imageProvider = FileImage(_controller.avatarFile!);
      }
    } else if (_controller.currentAvatarUrl != null &&
        _controller.currentAvatarUrl!.isNotEmpty) {
      final path = _controller.currentAvatarUrl!;
      if (kIsWeb || path.startsWith('http') || path.startsWith('blob:')) {
        imageProvider = NetworkImage(path);
      } else {
        imageProvider = FileImage(File(path));
      }
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surfaceElevated, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neutral900.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 54,
                backgroundColor: AppColors.neutral200,
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? const Icon(
                        Icons.person,
                        size: 58,
                        color: AppColors.textOnDark,
                      )
                    : null,
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: _showImagePickerModal,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.lime,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surfaceElevated,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neutral900.withValues(alpha: 0.26),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.charcoal,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _showImagePickerModal,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              'Ganti Foto Profil',
              style: AppTextStyles.label().copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Nama Lengkap / Username',
            hint: 'Contoh: Midou_kun',
            controller: _controller.nameController,
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),
          // EMAIL FIELD REMOVED - karena Google Sign-In tidak allow email change
          // Email akan di-set otomatis dari Google Account
          _buildReadOnlyField(
            label: 'Email (dari Google Account)',
            value: _controller.currentUser.email,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Nomor WhatsApp / Telepon',
            hint: 'Contoh: 0812-3456-7890',
            controller: _controller.phoneController,
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Lokasi / Asal Kampus / Domisili',
            hint: 'Contoh: Bekasi, Jawa Barat',
            controller: _controller.locationController,
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Bio / Deskripsi Toko',
            hint: 'Ceritakan sedikit tentang dirimu atau tokomu...',
            controller: _controller.bioController,
            prefixIcon: Icons.notes_rounded,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  /// Read-only field untuk menampilkan email (tidak bisa diedit)
  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label().copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Row(
            children: [
              Icon(
                prefixIcon,
                size: 20,
                color: AppColors.neutral600,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : 'Tidak ada email',
                  style: AppTextStyles.body().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutral600,
                  ),
                ),
              ),
              const Icon(
                Icons.lock_outline,
                size: 16,
                color: AppColors.neutral400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label().copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTextStyles.body().copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: AppTextStyles.body().copyWith(
              fontSize: 13.5,
              color: AppColors.neutral400,
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: 20,
              color: AppColors.neutral600,
            ),
            filled: true,
            fillColor: AppColors.surfacePage,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.neutral200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.neutral200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.charcoal, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.charcoal,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _controller.isLoading ? null : _handleSave,
        child: _controller.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.charcoal),
                ),
              )
            : Text(
                'Simpan Perubahan',
                style: AppTextStyles.label().copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.charcoal,
                ),
              ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded,
                color: AppColors.errorBase, size: 24),
            SizedBox(width: 8),
            Text(
              'Konfirmasi Keluar',
              style: AppTextStyles.h5().copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun RePake Anda?',
          style: AppTextStyles.body().copyWith(fontSize: 14.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: AppTextStyles.label().copyWith(
                color: AppColors.neutral700,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorBase,
              foregroundColor: AppColors.textOnDark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AuthController.instance.logout();
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Anda telah keluar dari akun RePake.'),
                  backgroundColor: AppColors.charcoal,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.errorBase,
          side: const BorderSide(color: AppColors.errorBase, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _confirmLogout,
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: Text(
          'Keluar dari Akun',
          style: AppTextStyles.label().copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 14.5,
            color: AppColors.errorBase,
          ),
        ),
      ),
    );
  }
}
