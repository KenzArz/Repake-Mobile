import 'package:flutter/material.dart';

import '../../controllers/AuthController.dart';
import '../auth/login_popup.dart';
import '../chat/chat_list_screen.dart';
import '../favorite/favorite_screen.dart';
import '../home/home_screen.dart';
import '../product/add_product_screen.dart';
import 'main_shell.dart';

/// Navbar untuk Mahasiswa / Guest: Home, Favorite, Jual, Chat.
/// Aktor Guest dibatasi hanya bisa melihat Home. Jika Guest menekan
/// tab Favorite, Jual, atau Chat, akan muncul Pop-up "Masuk ke RePake".
class UserNavbar extends StatelessWidget {
  const UserNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return MainShell(
      // Menu di navbar bawah (urutannya harus sama dengan `pages` di bawah).
      items: const [
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
      pages: const [
        HomeScreen(),
        FavoriteScreen(),
        AddProductScreen(),
        ChatListScreen(),
      ],
      // Validasi hak akses guest vs user
      onBeforeChange: (targetIndex) {
        if (targetIndex > 0 && AuthController.instance.isGuest) {
          showLoginPopup(context);
          return false;
        }
        return true;
      },
    );
  }
}
