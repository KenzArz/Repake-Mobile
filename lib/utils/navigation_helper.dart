import 'package:flutter/material.dart';

import '../controllers/AuthController.dart';
import '../models/ProductModel.dart';
import '../views/auth/login_popup.dart';
import '../views/product/product_detail.dart';

/// Centralized navigation helper untuk menghindari code duplication.
/// Single source of truth untuk semua navigasi dalam app.
class NavigationHelper {
  NavigationHelper._(); // Private constructor untuk prevent instantiation

  /// Navigate ke profile page (seller atau user profile)
  ///
  /// Digunakan oleh:
  /// - TopAppBar onProfileTap
  /// - Product card seller tap
  /// - Chat user avatar tap
  ///
  /// Jika user adalah guest, akan menampilkan login popup terlebih dahulu.
  static Future<void> toProfile(BuildContext context, {String? userId}) {
    // Cek apakah user adalah guest
    if (AuthController.instance.isGuest) {
      // Tampilkan login popup dari temanmu
      return showLoginPopup(context).then((success) {
        // Jika login berhasil, buka profile
        if (success == true && context.mounted) {
          return Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (context) => const SellerProfilePage(isOwnProfile: true),
            ),
          );
        }
      });
    }

    // User sudah login, langsung buka profile
    // TODO: Jika userId provided, load specific user profile
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => SellerProfilePage(isOwnProfile: userId == null),
      ),
    );
  }

  /// Navigate ke product detail page
  static Future<void> toProductDetail(
    BuildContext context,
    ProductModel product,
  ) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  /// Navigate back (safe wrapper dengan check)
  static void back(BuildContext context, {dynamic result}) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    }
  }

  /// Push replacement (replace current route)
  static Future<void> toReplacement(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
