import 'package:flutter/material.dart';

import '../../controllers/AuthController.dart';
import '../../models/DummyData.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/navigation_helper.dart';
import '../auth/login_popup.dart';
import '../navigation/top_appBar.dart';
import '../product/widgets/product_card.dart';
import 'widgets/banner_slider.dart';
import 'widgets/category_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  // Kategori produk dari DummyData (no more hardcoded!)
  final _categories = DummyData.categories;

  // Ambil data dari centralized DummyData
  late List<ProductModel> _nearby = DummyData.productsNearby(4);
  late List<ProductModel> _latest = DummyData.productsLatest(6);

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(ProductModel p) {
    if (AuthController.instance.isGuest) {
      showLoginPopup(context);
      return;
    }
    ProductModel flip(ProductModel x) =>
        x.id == p.id ? x.copyWith(isFavorite: !x.isFavorite) : x;
    setState(() {
      _nearby = _nearby.map(flip).toList();
      _latest = _latest.map(flip).toList();
    });
    // TODO: simpan ke backend lewat controller.
  }

  Widget _card(ProductModel p) {
    return ProductCard(
      product: p,
      onTap: () => NavigationHelper.toProductDetail(context, p),
      onFavoriteTap: () => _toggleFavorite(p),
      onMoreTap: () {
        // TODO: menu "Laporkan" dll.
      },
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(text, style: AppTextStyles.h4()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rowCount = (_latest.length + 1) ~/ 2;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopAppBar(
              scrollController: _scrollController,
              searchController: _searchController,
              onSearchSubmitted: (query) {
                // TODO: panggil product_controller untuk mencari
              },
              onProfileTap: () => NavigationHelper.toProfile(context),
            ),
            Expanded(
              child: CustomScrollView(
                controller: _scrollController, // wajib sama dengan appbar
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  // Banner dengan data dari DummyData
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: BannerSlider(
                        imageUrls: DummyData.bannerImageUrls,
                      ),
                    ),
                  ),

                  // Kategori
                  SliverToBoxAdapter(child: _sectionTitle('Mau cari apa?')),
                  SliverToBoxAdapter(
                    child: CategoryList(
                      categories: _categories,
                      onTap: (c) {
                        // TODO: buka halaman produk per kategori
                      },
                    ),
                  ),

                  // Dekat kamu (scroll ke samping - FIXED WIDTH 175)
                  SliverToBoxAdapter(child: _sectionTitle('Ada di Dekat Kamu')),
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var i = 0; i < _nearby.length; i++) ...[
                              if (i > 0) const SizedBox(width: 12),
                              // FIXED: Width tetap 175px untuk konsistensi
                              SizedBox(width: 175, child: _card(_nearby[i])),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Terbaru (grid 2 kolom)
                  SliverToBoxAdapter(child: _sectionTitle('Baru di Repake')),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, row) {
                          final a = _latest[row * 2];
                          final bIndex = row * 2 + 1;
                          final b =
                              bIndex < _latest.length ? _latest[bIndex] : null;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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

                  // Ruang kosong di bawah supaya tidak tertutup tombol "+"
                  const SliverToBoxAdapter(child: SizedBox(height: 96)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
