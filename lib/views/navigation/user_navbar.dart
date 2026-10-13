import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../product/add_product_screen.dart';
import 'main_shell.dart';

/// Navbar untuk Mahasiswa / Guest: Home, Favorite, Jual, Chat.
/// Semua logika navbar ada di MainShell; file ini hanya mengisi menu dan halaman.
class UserNavbar extends StatelessWidget {
  const UserNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainShell(
      // Menu di navbar bawah (urutannya harus sama dengan `pages` di bawah).
      items: [
        NavItemData(
          label: 'Home',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
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
      // Halaman untuk tiap menu.
      // TODO: ganti placeholder dengan layar asli (favorit, ChatListScreen).
      pages: [
        HomeScreen(),
        PlaceholderPage('Favorit'),
        AddProductScreen(),
        PlaceholderPage('Chat'),
      ],
    );
  }
}