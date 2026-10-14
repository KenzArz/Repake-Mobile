import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/ProfileController.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_colors.dart';
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
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.errorBase, size: 24),
            SizedBox(width: 8),
            Text(
              'Konfirmasi Keluar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun RePake Anda?',
          style: TextStyle(fontSize: 14.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.neutral700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorBase,
              foregroundColor: Colors.white,
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

  late final List<ProductModel> _sellerProducts = [
    ProductModel(
      id: 'sel_1',
      title: 'Femboy imup ganas',
      price: 670000,
      sellerName: widget.sellerName,
      location: widget.location,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      condition: 'Dirawat dengan baik',
      status: 'Dijual',
      imageUrl:
          'https://images.unsplash.com/photo-1578632767115-351597cf2477?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    ),
    ProductModel(
      id: 'sel_2',
      title: 'Kemeja pria warna merah motif kotak lengan panjang',
      price: 170000,
      sellerName: widget.sellerName,
      location: widget.location,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      condition: 'Dirawat dengan baik',
      status: 'Dijual',
      imageUrl:
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    ),
    ProductModel(
      id: 'sel_3',
      title: 'Sepatu adidas asli ori real warna hitam ukuran a4',
      price: 250000,
      sellerName: widget.sellerName,
      location: widget.location,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      condition: 'Jarang Digunakan',
      status: 'Dijual',
      imageUrl:
          'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    ),
    ProductModel(
      id: 'sel_4',
      title: 'Keyboard pemda bekas reza auditore asli no hoax',
      price: 670000,
      sellerName: widget.sellerName,
      location: widget.location,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      condition: 'Dirawat dengan baik',
      status: 'Dijual',
      imageUrl:
          'https://images.unsplash.com/photo-1587829741301-dc798b83add3?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    ),
    ProductModel(
      id: 'sel_5',
      title: 'Samsung galaxy ear buds',
      price: 100000,
      sellerName: widget.sellerName,
      location: widget.location,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      condition: 'Dirawat dengan baik',
      status: 'Dijual',
      imageUrl:
          'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
    ),
  ];

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
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              displayName,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.black87),
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
                icon: const Icon(Icons.share, color: Colors.black87),
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
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: avatarImage,
                                child: avatarImage == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.white,
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
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
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
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.verified,
                                      color: Color(0xFF4C8B4A),
                                      size: 18,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '📍 $displayLocation • Online 10 menit lalu',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.rating} (48 ulasan)',
                                      style: const TextStyle(
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
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            user.bio,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade700,
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
                                  foregroundColor: Colors.black87,
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
                                label: const Text(
                                  'Edit Profil',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                label: const Text(
                                  'Keluar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                      : Colors.white,
                                  side: BorderSide(
                                    color: _isFollowing
                                        ? const Color(0xFF81973D)
                                        : Colors.grey.shade400,
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
                                  style: const TextStyle(
                                    color: Colors.black87,
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
                                  foregroundColor: Colors.black87,
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
                                label: const Text(
                                  'Chat',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Urutkan: Terbaru',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
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
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading:
                    const Icon(Icons.share_outlined, color: Colors.black87),
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
                title: const Text(
                  'Laporkan Produk',
                  style: TextStyle(color: AppColors.errorBase),
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
                  style: const TextStyle(
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
                  foregroundColor: Colors.black87,
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
