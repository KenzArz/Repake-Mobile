import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../models/ProductModel.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

/// ---------------------------------------------------------------------------
/// KARTU PRODUK UTAMA (ProductCard)
/// ---------------------------------------------------------------------------
/// Membungkus seluruh tampilan kartu. Lebarnya menyesuaikan ruang yang tersedia
/// (misal dari GridView atau Row/Expanded).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onMoreTap,
    this.titleMaxLines = 2,
    this.sellerAvatarImage,
  });

  final ProductModel product;
  final VoidCallback? onTap; // Aksi saat kartu ditekan (buka detail)
  final VoidCallback? onFavoriteTap; // Aksi saat tombol favorit ditekan
  final VoidCallback? onMoreTap; // Aksi saat tombol titik tiga ditekan
  final int titleMaxLines;
  final ImageProvider? sellerAvatarImage;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated, // Warna background kartu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Lengkungan sudut kartu
        side: const BorderSide(color: AppColors.borderDefault),
      ),
      clipBehavior: Clip.antiAlias, // Memotong child agar ikutan melengkung
      child: InkWell(
        onTap: onTap, // Efek gelombang (ripple) saat kartu diklik
        child: Padding(
          padding: const EdgeInsets.all(8), // Jarak dalam kartu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Informasi Penjual (Foto, Nama, Lokasi, Titik Tiga)
              _SellerRow(
                product: product,
                onMoreTap: onMoreTap,
                sellerAvatarImage: sellerAvatarImage,
              ),
              const SizedBox(height: 8),

              // 2. Gambar Produk + Badge Status + Tombol Favorit
              _ImageWithOverlay(
                product: product,
                onFavoriteTap: onFavoriteTap,
              ),
              const SizedBox(height: 8),

              // 3. Judul Produk
              Text(
                product.title,
                maxLines: titleMaxLines,
                overflow: TextOverflow
                    .ellipsis, // Bikin teks jadi '...' kalau kepanjangan
                style: AppTextStyles.body().copyWith(
                  fontSize: 13.5,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),

              // 4. Harga Produk
              Text(
                product.priceLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h5().copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              // 5. Chip/Badge Kondisi Barang (misal: "Dirawat dengan baik")
              Align(
                alignment: Alignment.centerLeft,
                child: _ConditionChip(label: product.condition),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// BARIS PENJUAL (_SellerRow)
/// ---------------------------------------------------------------------------
/// Menampilkan foto profil penjual, nama, lokasi/waktu posting, dan opsi titik tiga.
class _SellerRow extends StatelessWidget {
  const _SellerRow({
    required this.product,
    this.onMoreTap,
    this.sellerAvatarImage,
  });

  final ProductModel product;
  final VoidCallback? onMoreTap;
  final ImageProvider? sellerAvatarImage;

  @override
  Widget build(BuildContext context) {
    ImageProvider? avatar = sellerAvatarImage;
    if (avatar == null &&
        product.sellerAvatarUrl != null &&
        product.sellerAvatarUrl!.isNotEmpty) {
      if (kIsWeb ||
          product.sellerAvatarUrl!.startsWith('http') ||
          product.sellerAvatarUrl!.startsWith('blob:')) {
        avatar = NetworkImage(product.sellerAvatarUrl!);
      } else {
        final f = File(product.sellerAvatarUrl!);
        if (f.existsSync()) {
          avatar = FileImage(f);
        } else {
          avatar = NetworkImage(product.sellerAvatarUrl!);
        }
      }
    }

    return Row(
      children: [
        // Foto profil bulat penjual
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.neutral200,
          backgroundImage: avatar,
        ),
        const SizedBox(width: 8),

        // Nama penjual & lokasi/waktu
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.sellerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label().copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${product.location} · ${product.postedAgo}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption().copyWith(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),

        // Tombol opsi titik tiga (misal untuk "Laporkan")
        InkResponse(
          onTap: onMoreTap,
          radius: 16,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: Icon(
              Icons.more_vert,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// GAMBAR PRODUK DENGAN OVERLAY (_ImageWithOverlay)
/// ---------------------------------------------------------------------------
/// Bagian ini mengatur tinggi/proporsi gambar serta menaruh Badge Status
/// dan Tombol Favorit melayang di atas gambar.
class _ImageWithOverlay extends StatelessWidget {
  const _ImageWithOverlay({required this.product, this.onFavoriteTap});

  final ProductModel product;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      /// PERSENTASE PROPORSI GAMBAR (Lebar : Tinggi)
      /// - 1.25 = Lebih lebar / pendek (Landscape)
      /// - 1.0  = Persegi pas (1:1)
      /// - 0.85 = LEBIH TINGGI (Portrait) -> Makin kecil nilainya, makin tinggi gambarnya
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Melengkungkan sudut gambar
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Gambar Utama Produk
            _ProductImage(url: product.imageUrl),

            // 2. Badge Status (Melayang di Pojok Kiri Atas Gambar)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  product.status,
                  style: AppTextStyles.label().copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
              ),
            ),

            // 3. Tombol Favorit (Melayang di Pojok Kanan Atas Gambar)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onFavoriteTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(
                        0x73202320), // Background lingkaran hitam transparan
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: product.isFavorite
                        ? AppColors.lime
                        : AppColors.textOnDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// RENDER GAMBAR / PLACEHOLDER (_ProductImage)
/// ---------------------------------------------------------------------------
/// Menampilkan gambar dari URL internet, atau tampilan kotak abu-abu kalau
/// gambarnya kosong / gagal dimuat.
class _ProductImage extends StatelessWidget {
  const _ProductImage({this.url});

  final String? url;

  // Tampilan cadangan kalau gambar tidak ada / error
  Widget _placeholder() => Container(
        color: AppColors.neutral200,
        child: const Center(
          child: Icon(Icons.image_outlined, color: AppColors.neutral400),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (url == null) return _placeholder();
    return Image.network(
      url!,
      fit: BoxFit.cover, // Memastikan gambar memenuhi area tanpa gepeng
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CHIP KONDISI BARANG (_ConditionChip)
/// ---------------------------------------------------------------------------
/// Label kecil di bagian paling bawah kartu (misal: "Dirawat dengan baik").
class _ConditionChip extends StatelessWidget {
  const _ConditionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lime50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption().copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
