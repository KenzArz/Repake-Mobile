import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../home/home_screen.dart';
// import '../product/add_product_screen.dart';

/// Kerangka utama untuk user: isi halaman + navbar bawah (Home, Favorit, Chat)
/// + tombol "+" (jual produk). Appbar atas dipasang di tiap halaman.
class UserNavbar extends StatefulWidget {
  const UserNavbar({super.key});

  @override
  State<UserNavbar> createState() => _UserNavbarState();
}

class _UserNavbarState extends State<UserNavbar> {
  int _index = 0;

  // IndexedStack menjaga posisi scroll tiap tab.
  // TODO: ganti placeholder dengan layar asli (favorit, ChatListScreen).
  static const _pages = <Widget>[
    HomeScreen(),
    _PlaceholderPage('Favorit'),
    _PlaceholderPage('Jual'),
    _PlaceholderPage('Chat'),
  ];

  @override
  Widget build(BuildContext context) {
    // Saat keyboard terbuka, sembunyikan navbar & tombol "+".
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      // tampil di semua tab.
      bottomNavigationBar: keyboardOpen
          ? null
          : _BottomPill(
              index: _index,
              onChanged: (i) => setState(() => _index = i),
            ),
    );
  }
}

class _BottomPill extends StatelessWidget {
  const _BottomPill({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Material(
        color: AppColors.surfacePage,
        shape: const StadiumBorder(
          side: BorderSide(color: AppColors.textPrimary),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                label: 'Home',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                selected: index == 0,
                onTap: () => onChanged(0),
              ),
              _NavItem(
                label: 'Favorite',
                icon: Icons.favorite_border,
                selectedIcon: Icons.favorite,
                selected: index == 1,
                onTap: () => onChanged(1),
              ),
              _NavItem(
                label: 'Jual',
                icon: Icons.add_circle_outline_rounded,
                selectedIcon: Icons.add_circle_rounded,
                selected: index == 2,
                onTap: () => onChanged(2),
              ),
              _NavItem(
                label: 'Chat',
                icon: Icons.chat_bubble_outline_rounded,
                selectedIcon: Icons.chat_bubble_rounded,
                selected: index == 3,
                onTap: () => onChanged(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.lime700 : AppColors.textPrimary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? selectedIcon : icon, size: 26, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption().copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(child: Text(title, style: AppTextStyles.h4())),
    );
  }
}
