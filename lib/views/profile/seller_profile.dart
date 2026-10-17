import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/ProfileController.dart';
import '../../models/DummyData.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../product/product_detail.dart';
import '../product/widgets/product_card.dart';
import 'edit_profile_screen.dart';

/// Halaman Profil Penjual (Seller Profile Page).
/// Menampilkan informasi toko/penjual, rating, statistik, dan barang-barang yang dijual.
class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({
    super.key,
    this.sellerName = 'Midou_kun',
    this.location = 'Bekasi',
    this.rating = 4.5,
    this.isOwnProfile = false,
  });

  final String sellerName;
  final String location;
  final double rating;
  final bool isOwnProfile;

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  // Using AppColors.lime from theme system instead of hardcoded AppColors.lime
  bool _isFollowing = false;

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.errorBase, size: 24),
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

  // Gunakan DummyData untuk seller products (no more hardcoded!)
  late final List<ProductModel> _sellerProducts =
      DummyData.productsForSeller(widget.sellerName, widget.location);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ProfileController.instance,
      builder: (context, _) {
        final user = ProfileController.instance.currentUser;
        final displayName =
            user.name.isNotEmpty ? user.name : widget.sellerName;
        final displayLocation =
            user.location.isNotEmpty ? user.location : widget.location;

        ImageProvider? avatarImage;
        if (!kIsWeb && ProfileController.instance.avatarFile != null) {
          avatarImage = FileImage(ProfileController.instance.avatarFile!);
        } else if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
          if (kIsWeb ||
              user.avatarUrl!.startsWith('http') ||
              user.avatarUrl!.startsWith('blob:')) {
            avatarImage = NetworkImage(user.avatarUrl!);
          } else {
            final file = File(user.avatarUrl!);
            if (file.existsSync()) {
              avatarImage = FileImage(file);
            } else {
              avatarImage = NetworkImage(user.avatarUrl!);
            }
          }
        }

        final isSelf = widget.isOwnProfile ||
            (user.name.isNotEmpty && user.name == widget.sellerName);

        return Scaffold(
          backgroundColor: AppColors.surfacePage,
          appBar: AppBar(
            backgroundColor: AppColors.surfaceElevated,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              displayName,
              style: AppTextStyles.h5().copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.textPrimary,
                ),
                tooltip: 'Edit Profil',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                  // TIDAK PERLU setState - ProfileController.notifyListeners() sudah handle rebuild
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: AppColors.textPrimary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tautan profil $displayName disalin!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header info penjual
                Container(
                  color: AppColors.surfaceElevated,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: AppColors.neutral300,
                                backgroundImage: avatarImage,
                                child: avatarImage == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppColors.textOnDark,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: AppColors.successBase,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.surfaceElevated,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      displayName,
                                      style: AppTextStyles.h5().copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.verified,
                                      color: AppColors.successBase,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '📍 $displayLocation • Online 10 menit lalu',
                                  style: AppTextStyles.caption().copyWith(
                                    color: AppColors.neutral600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: AppColors.ratingYellow,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.rating} (48 ulasan)',
                                      style: AppTextStyles.label().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (user.bio.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neutral50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.neutral100),
                          ),
                          child: Text(
                            user.bio,
                            style: AppTextStyles.body().copyWith(
                              fontSize: 12.5,
                              color: AppColors.neutral700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Tombol Ikuti & Chat ATAU Edit Profil & Keluar
                      if (isSelf)
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.lime,
                                  foregroundColor: AppColors.textPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfileScreen(),
                                    ),
                                  );
                                  setState(() {});
                                },
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                label: Text(
                                  'Edit Profil',
                                  style: AppTextStyles.label().copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.errorBase,
                                  side: const BorderSide(
                                      color: AppColors.errorBase, width: 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () => _confirmLogout(context),
                                icon:
                                    const Icon(Icons.logout_rounded, size: 18),
                                label: Text(
                                  'Keluar',
                                  style: AppTextStyles.label().copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _isFollowing
                                      ? AppColors.lime.withAlpha(50)
                                      : AppColors.surfaceElevated,
                                  side: BorderSide(
                                    color: _isFollowing
                                        ? AppColors.lime700
                                        : AppColors.neutral400,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isFollowing = !_isFollowing;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_isFollowing
                                          ? 'Mengikuti ${widget.sellerName}'
                                          : 'Berhenti mengikuti ${widget.sellerName}'),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Text(
                                  _isFollowing
                                      ? '✓ Mengikuti'
                                      : '+ Ikuti Penjual',
                                  style: AppTextStyles.label().copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.lime,
                                  foregroundColor: AppColors.textPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  _showChatBottomSheet(context);
                                },
                                icon: const Icon(Icons.chat_bubble_outline,
                                    size: 18),
                                label: Text(
                                  'Chat',
                                  style: AppTextStyles.label().copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Header Daftar Produk
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Semua Produk (${_sellerProducts.length})',
                        style: AppTextStyles.h5().copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Urutkan: Terbaru',
                        style: AppTextStyles.caption().copyWith(
                          fontSize: 12,
                          color: AppColors.neutral600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Grid Produk Penjual (2 Kolom Menggunakan ProductCard Sesuai Desain PDF)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (int i = 0; i < _sellerProducts.length; i += 2) ...[
                        if (i > 0) const SizedBox(height: 12),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildProductCard(
                                  context,
                                  _sellerProducts[i],
                                  avatarImage,
                                  displayName,
                                  displayLocation,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: (i + 1 < _sellerProducts.length)
                                    ? _buildProductCard(
                                        context,
                                        _sellerProducts[i + 1],
                                        avatarImage,
                                        displayName,
                                        displayLocation,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductModel item,
    ImageProvider? avatarImage,
    String displayName,
    String displayLocation,
  ) {
    // Sinkronkan nama penjual dan lokasi dengan profil saat ini
    final productWithSeller = item.copyWith(
      sellerName: displayName,
      location: displayLocation,
    );

    return ProductCard(
      product: productWithSeller,
      sellerAvatarImage: avatarImage,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: productWithSeller,
            ),
          ),
        );
      },
      onFavoriteTap: () {
        if (AuthController.instance.isGuest) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Silakan masuk untuk menyimpan favorit.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        setState(() {
          final idx = _sellerProducts.indexWhere((p) => p.id == item.id);
          if (idx != -1) {
            _sellerProducts[idx] = _sellerProducts[idx].copyWith(
              isFavorite: !_sellerProducts[idx].isFavorite,
            );
          }
        });
      },
      onMoreTap: () => _showProductOptions(context, productWithSeller),
    );
  }

  void _showProductOptions(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(
                  Icons.share_outlined,
                  color: AppColors.textPrimary,
                ),
                title: const Text('Bagikan Produk'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tautan "${product.title}" disalin!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.flag_outlined, color: AppColors.errorBase),
                title: Text(
                  'Laporkan Produk',
                  style: AppTextStyles.label().copyWith(
                    color: AppColors.errorBase,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Laporan Anda telah dikirim.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChatBottomSheet(BuildContext context) {
    final msgCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chat dengan ${widget.sellerName}',
                  style: AppTextStyles.label().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: msgCtrl,
              decoration: InputDecoration(
                hintText: 'Tulis pesan Anda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lime,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pesan terkirim ke ${widget.sellerName}!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Kirim Pesan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
