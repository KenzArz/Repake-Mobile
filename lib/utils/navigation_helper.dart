import 'package:flutter/material.dart';

import '../views/product/product_detail.dart';
import '../models/ProductModel.dart';

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
  static Future<void> toProfile(BuildContext context, {String? userId}) {
    // TODO: Jika userId provided, load specific user profile
    // Untuk sekarang, selalu buka SellerProfilePage
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => const SellerProfilePage(),
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
