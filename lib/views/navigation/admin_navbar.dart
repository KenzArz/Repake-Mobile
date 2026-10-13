import 'package:flutter/material.dart';
import 'package:projectrepake/views/product/add_product_screen.dart';

import '../admin/admin_dashboard_screen.dart';
import '../home/home_screen.dart';
import 'main_shell.dart';

/// Navbar untuk Admin: Home, Dashboard, Favorite, Chat.
/// Admin tidak punya menu "Jual". Ubah daftar di bawah kalau ingin menambah
/// atau mengurangi menu.
class AdminNavbar extends StatelessWidget {
  const AdminNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainShell(
      items: [
        NavItemData(
          label: 'Home',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
        ),
        NavItemData(
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard_rounded,
        ),
        NavItemData(
          label: 'Favorite',
          icon: Icons.favorite_border,
          selectedIcon: Icons.favorite,
        ),
        NavItemData(
          label: 'Jual',
          icon: Icons.add_circle_outline_rounded,
          selectedIcon: Icons.add_circle_rounded,
        ),
        NavItemData(
          label: 'Chat',
          icon: Icons.chat_bubble_outline_rounded,
          selectedIcon: Icons.chat_bubble_rounded,
        ),
      ],
      pages: [
        HomeScreen(),
        AdminDashboardScreen(),
        PlaceholderPage('Favorit'),
        AddProductScreen(),
        PlaceholderPage('Chat'),
      ],
    );
  }
}
