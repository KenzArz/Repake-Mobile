import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'banner_manage_screen.dart';
import 'report_list_screen.dart';

/// Halaman Dashboard Admin. Berisi 3 tab:
///   1. Laporan  -> ReportListScreen      (Rafis)
///   2. Kategori -> belum dibuat          (Aldi, category_form.dart)
///   3. Banner   -> BannerManageScreen    (atur banner beranda)
///
/// Untuk menambah / menghapus tab: ubah `length`, daftar `tabs`,
/// dan daftar `children` di TabBarView (jumlahnya harus sama).
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController menghubungkan TabBar (tombol tab) dengan
    // TabBarView (isi tab) secara otomatis.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // --- Judul halaman ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Text('Dashboard', style: AppTextStyles.h3()),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lime200,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Admin',
                        style: AppTextStyles.caption()
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Tombol tab (bentuk pil) ---
              const _DashboardTabBar(),

              // --- Isi tab ---
              const Expanded(
                child: TabBarView(
                  children: [
                    ReportListScreen(),
                    _CategoryPlaceholder(),
                    BannerManageScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTabBar extends StatelessWidget {
  const _DashboardTabBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: TabBar(
          // Tab yang aktif diberi latar hijau lime berbentuk pil.
          indicator: BoxDecoration(
            color: AppColors.lime,
            borderRadius: BorderRadius.circular(999),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent, // hilangkan garis bawah bawaan
          splashBorderRadius: BorderRadius.circular(999),
          labelColor: AppColors.charcoal,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle:
              AppTextStyles.label().copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: AppTextStyles.label(),
          tabs: const [
            Tab(text: 'Laporan', height: 36),
            Tab(text: 'Kategori', height: 36),
            Tab(text: 'Banner', height: 36),
          ],
        ),
      ),
    );
  }
}

/// Tab Kategori masih kosong (dikerjakan Aldi).
/// Nanti ganti `_CategoryPlaceholder()` di atas dengan layar kategori asli.
class _CategoryPlaceholder extends StatelessWidget {
  const _CategoryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.category_outlined,
              size: 40, color: AppColors.neutral400),
          const SizedBox(height: 12),
          Text('Kelola Kategori', style: AppTextStyles.h5()),
          const SizedBox(height: 4),
          Text(
            'Belum dibuat.',
            style:
                AppTextStyles.body().copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}