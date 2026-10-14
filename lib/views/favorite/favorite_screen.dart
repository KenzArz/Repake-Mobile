import 'package:flutter/material.dart';

import '../../controllers/AuthController.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/navigation_helper.dart';
import '../../widgets/wireframe_overlay.dart';
import '../auth/login_popup.dart';
import '../navigation/top_appBar.dart';
import '../product/widgets/product_card.dart';

/// Halaman Favorite - Menampilkan daftar produk yang sudah di-favorite user.
/// Layout menggunakan grid 2 kolom yang sama dengan landing page (home_screen).
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  // TODO: Ganti dengan FavoriteController.instance.getFavorites()
  // Untuk demo UI, pakai data dummy
  late List<ProductModel> _favorites = _dummyFavorites(8);

  static List<ProductModel> _dummyFavorites(int n) {
    return List.generate(
      n,
      (i) => ProductModel(
        id: 'fav$i',
        title: [
          'Keyboard Mechanical RGB Gaming',
          'Sepatu Sneakers Bekas Limited Edition',
          'Jaket Denim Vintage 90s',
          'Kamera DSLR Canon EOS 70D',
          'Headphone Wireless Sony WH-1000XM4',
          'Tas Ransel North Face Original',
          'Buku Harry Potter Seri Lengkap',
          'Smart Watch Apple Watch Series 7',
        ][i % 8],
        price: [
          670000,
          450000,
          280000,
          5500000,
          3200000,
          890000,
          750000,
          4500000
        ][i % 8],
        sellerName: ['Midou_kun', 'Reza_shop', 'Thrift.id', 'TechStore'][i % 4],
        location: ['Bekasi', 'Jakarta', 'Bandung', 'Tangerang'][i % 4],
        createdAt: DateTime.now().subtract(Duration(hours: i * 3)),
        condition: [
          'Dirawat dengan baik',
          'Seperti baru',
          'Bekas pakai'
        ][i % 3],
        status: 'Dijual',
        isFavorite: true,
        // imageUrl: null,  // Hapus image URL
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(ProductModel p) {
    // Cek guest dulu
    if (AuthController.instance.isGuest) {
      showLoginPopup(context);
      return;
    }

    setState(() {
      // Remove dari list favorite (unfavorite)
      _favorites = _favorites.where((x) => x.id != p.id).toList();
    });

    // TODO: Update via FavoriteController.instance.toggleFavorite(p.id)

    // Show snackbar feedback dengan undo action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: WText(
          '💔 Produk dihapus dari Favorit',
          style: AppTextStyles.body().copyWith(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'BATAL',
          textColor: Color(0xFFE0E0E0),
          onPressed: () {
            // Restore item (undo action)
            setState(() {
              _favorites.add(p);
            });
          },
        ),
      ),
    );
  }

  Widget _card(ProductModel p) {
    return ProductCard(
      product: p,
      onTap: () => NavigationHelper.toProductDetail(context, p),
      onFavoriteTap: () => _toggleFavorite(p),
      onMoreTap: () {
        _showProductOptions(p);
      },
    );
  }

  void _showProductOptions(ProductModel product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading:
                    const Icon(Icons.share_outlined, color: AppColors.charcoal),
                title: const WText('Bagikan Produk'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: WText('Tautan "${product.title}" disalin!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.flag_outlined, color: AppColors.errorBase),
                title: WText(
                  'Laporkan Produk',
                  style: AppTextStyles.label().copyWith(
                    color: AppColors.errorBase,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: WText('Laporan dikirim. Terima kasih!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(text, style: AppTextStyles.h4()),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            WText(
              subtitle,
              style: AppTextStyles.body().copyWith(
                fontSize: 13,
                color: AppColors.neutral600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hitung jumlah row untuk grid 2 kolom
    final rowCount = (_favorites.length + 1) ~/ 2;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopAppBar(
              scrollController: _scrollController,
              searchController: _searchController,
              onSearchSubmitted: (query) {
                // TODO: Search dalam favorite products
              },
              onProfileTap: () => NavigationHelper.toProfile(context),
            ),
            Expanded(
              child: _favorites.isEmpty
                  ? _buildEmptyState()
                  : CustomScrollView(
                      controller: _scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        // Header dengan jumlah item
                        SliverToBoxAdapter(
                          child: _sectionTitle(
                            'Produk Favorit',
                            subtitle: '${_favorites.length} produk tersimpan',
                          ),
                        ),

                        // Grid 2 kolom - SAMA PERSIS dengan landing page
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, row) {
                                final a = _favorites[row * 2];
                                final bIndex = row * 2 + 1;
                                final b = bIndex < _favorites.length
                                    ? _favorites[bIndex]
                                    : null;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(child: _card(a)),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: b != null
                                              ? _card(b)
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount: rowCount,
                            ),
                          ),
                        ),

                        // Ruang kosong di bawah supaya tidak tertutup navbar
                        const SliverToBoxAdapter(child: SizedBox(height: 96)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state ketika belum ada produk favorite
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon besar
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.neutral100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 60,
                color: AppColors.neutral400,
              ),
            ),
            const SizedBox(height: 24),

            // Judul
            WText(
              'Belum Ada Favorit',
              style: AppTextStyles.h3().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Deskripsi
            WText(
              'Kamu belum menambahkan produk ke favorit.\nMulai jelajahi dan tandai produk yang kamu suka!',
              style: AppTextStyles.body().copyWith(
                color: AppColors.neutral600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Tombol CTA
            FilledButton.icon(
              onPressed: () {
                // Pindah ke tab Home
                // TODO: Implement navigation to home tab
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kembali ke Home untuk menjelajah produk!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xFFE0E0E0),
                foregroundColor: AppColors.charcoal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.explore_outlined),
              label: WText(
                'Jelajahi Produk',
                style: AppTextStyles.label().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
