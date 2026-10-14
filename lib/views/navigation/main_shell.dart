import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Data satu menu di navbar bawah.
class NavItemData {
  const NavItemData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon; // ikon saat tidak aktif
  final IconData selectedIcon; // ikon saat aktif
}

/// Kerangka halaman utama: isi halaman + navbar pil di bawah.
///
/// Dipakai bersama oleh UserNavbar dan AdminNavbar. Bedanya hanya di daftar
/// [items] (menu) dan [pages] (halaman). Urutan [items] harus sama dengan
/// urutan [pages].
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.items,
    required this.pages,
    this.onBeforeChange,
  });

  final List<NavItemData> items;
  final List<Widget> pages;
  final bool Function(int index)? onBeforeChange;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    assert(
      widget.items.length == widget.pages.length,
      'Jumlah items dan pages harus sama.',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Saat keyboard terbuka, sembunyikan navbar.
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      // IndexedStack menjaga posisi scroll & isi form tiap tab.
      body: IndexedStack(index: _index, children: widget.pages),
      bottomNavigationBar: keyboardOpen
          ? null
          : _BottomPillNav(
              items: widget.items,
              index: _index,
              onChanged: (i) {
                if (widget.onBeforeChange != null &&
                    !widget.onBeforeChange!(i)) {
                  return;
                }
                setState(() => _index = i);
              },
            ),
    );
  }
}

/// Navbar bentuk pil di bagian bawah.
class _BottomPillNav extends StatelessWidget {
  const _BottomPillNav({
    required this.items,
    required this.index,
    required this.onChanged,
  });

  final List<NavItemData> items;
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
              for (var i = 0; i < items.length; i++)
                _NavItem(
                  data: items[i],
                  selected: i == index,
                  onTap: () => onChanged(i),
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
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF757575) : AppColors.textPrimary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? data.selectedIcon : data.icon,
              size: 26,
              color: color,
            ),
            const SizedBox(height: 2),
            Text(
              data.label,
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

/// Halaman sementara untuk tab yang belum dibuat.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(child: Text(title, style: AppTextStyles.h4())),
    );
  }
}
