import 'package:flutter/material.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/ProductDetailController.dart';
import '../../models/ProductModel.dart';
import '../../theme/app_colors.dart';
import '../auth/login_popup.dart';
import 'widgets/product_detail_app_bar.dart';
import 'widgets/product_gallery.dart';
import 'widgets/product_info_section.dart';
import 'widgets/similar_products_section.dart';

// Re-export SellerProfilePage & ProductDetailController untuk kemudahan akses
export '../../controllers/ProductDetailController.dart';
export '../profile/seller_profile.dart' show SellerProfilePage;

/// Alias untuk kemudahan pemanggilan
typedef ProductDetail = ProductDetailPage;

/// Halaman View Detail Produk di aplikasi RePake (MVC Architecture - View Layer).
///
/// Tanggung jawab:
/// - Menyusun tata letak (Layout & Presentation) responsif Desktop & Mobile
/// - Menghubungkan user event (tap, input) ke [ProductDetailController]
/// - Menampilkan dialog, modal chat bottom sheet, dan feedback SnackBar
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    this.product,
    this.controller,
  });

  /// Data produk yang ditampilkan. Jika null, controller akan memakai data default.
  final ProductModel? product;

  /// Custom controller jika ingin diinjeksi dari luar (misal untuk testing / dependency injection)
  final ProductDetailController? controller;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final ProductDetailController _controller;
  late final bool _isLocalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isLocalController = false;
    } else {
      _controller = ProductDetailController(initialProduct: widget.product);
      _isLocalController = true;
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
  // USER ACTIONS / EVENT HANDLERS
  // ---------------------------------------------------------------------------

  void _toggleFavorite() {
    if (AuthController.instance.isGuest) {
      showLoginPopup(context);
      return;
    }

    _controller.toggleFavorite();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _controller.isFavorite
              ? '⭐ Produk ditambahkan ke Favorit!'
              : 'Produk dihapus dari Favorit',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitOffer() {
    if (AuthController.instance.isGuest) {
      showLoginPopup(context);
      return;
    }

    final resultMsg = _controller.submitOffer();
    if (resultMsg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan nominal penawaran harga'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resultMsg,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _openChatDialog() {
    if (AuthController.instance.isGuest) {
      showLoginPopup(context);
      return;
    }

    final messageController = TextEditingController(
      text:
          'Halo kak, apakah barang "${_controller.product.title.replaceAll('\n', ' ')}" masih ada?',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.lime,
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _controller.product.sellerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Online • Balas dalam beberapa menit',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text(
                'Kirim Pesan ke Penjual',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tulis pesan Anda...',
                  filled: true,
                  fillColor: AppColors.neutral50,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.neutral300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.neutral300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.charcoal),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: AppColors.charcoal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final text = messageController.text.trim();
                    if (text.isEmpty) return;
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '💬 Pesan berhasil dikirim ke ${_controller.product.sellerName}!'),
                        backgroundColor: AppColors.charcoal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send, size: 18),
                  label: const Text(
                    'Kirim Pesan Sekarang',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Laporkan Produk'),
        content: Text(
          'Apakah Anda ingin melaporkan produk "${_controller.product.title.replaceAll('\n', ' ')}" dari penjual ${_controller.product.sellerName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.errorBase),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Laporan Anda telah dikirim dan sedang ditinjau.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Laporkan',
                style: TextStyle(color: AppColors.textOnDark)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD METHOD (PRESENTATION LAYER)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfacePage,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 768;

            return ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return Column(
                  children: [
                    // 1. STICKY TOP APP BAR ("RePake", Wishlist)
                    ProductDetailAppBar(
                      title: 'RePake',
                      isWide: isWide,
                      isFavorite: _controller.isFavorite,
                      onFavoriteTap: _toggleFavorite,
                    ),

                    // 2. SCROLLABLE BODY CONTENT
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Konten Utama Produk (Galeri di kiri, Info di kanan jika Desktop)
                            Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 1200),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isWide ? 32.0 : 16.0,
                                    vertical: 24.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (isWide)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: ProductGallery(
                                                height: 430,
                                                images: _controller.images,
                                                selectedIndex: _controller
                                                    .selectedImageIndex,
                                                onSelectIndex:
                                                    _controller.selectImage,
                                              ),
                                            ),
                                            const SizedBox(width: 36),
                                            Expanded(
                                              flex: 5,
                                              child: ProductInfoSection(
                                                product: _controller.product,
                                                offerController:
                                                    _controller.offerController,
                                                onChatTap: _openChatDialog,
                                                onSubmitOffer: _submitOffer,
                                                onReportTap: _showReportDialog,
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ProductGallery(
                                              height: 320,
                                              images: _controller.images,
                                              selectedIndex: _controller
                                                  .selectedImageIndex,
                                              onSelectIndex:
                                                  _controller.selectImage,
                                            ),
                                            const SizedBox(height: 20),
                                            ProductInfoSection(
                                              product: _controller.product,
                                              offerController:
                                                  _controller.offerController,
                                              onChatTap: _openChatDialog,
                                              onSubmitOffer: _submitOffer,
                                              onReportTap: _showReportDialog,
                                            ),
                                          ],
                                        ),

                                      const SizedBox(height: 48),

                                      // 3. Rekomendasi Produk Serupa (4 Kartu)
                                      SimilarProductsSection(
                                        similarProducts:
                                            _controller.similarProducts,
                                        isWide: isWide,
                                        onProductTap: (item) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailPage(
                                                product: item,
                                              ),
                                            ),
                                          );
                                        },
                                        onFavoriteTap: (item) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Disimpan ke Favorit'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                        onReportTap: _showReportDialog,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
