import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../controllers/ProfileController.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../profile/seller_profile.dart';
import 'banner_manage_screen.dart';
import 'category_manage_screen.dart';
import 'report_list_screen.dart';
import '../../widgets/wireframe_overlay.dart';

/// Halaman Dashboard Admin. Berisi 3 tab:
///   1. Laporan  -> ReportListScreen      (melihat laporan pengguna)
///   2. Kategori -> CategoryManageScreen  (kelola kategori produk)
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
                    WText('Dashboard', style: AppTextStyles.h3()),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: WText(
                        'Admin',
                        style: AppTextStyles.caption()
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Spacer(),
                    ListenableBuilder(
                      listenable: ProfileController.instance,
                      builder: (context, _) {
                        final avatarFile = ProfileController.instance.avatarFile;
                        final avatarUrl =
                            ProfileController.instance.currentUser.avatarUrl;

                        ImageProvider? avatarImage;
                        if (avatarFile != null) {
                          if (kIsWeb) {
                            avatarImage = NetworkImage(avatarFile.path);
                          } else {
                            avatarImage = FileImage(avatarFile);
                          }
                        } else if (avatarUrl != null && avatarUrl.isNotEmpty) {
                          if (kIsWeb ||
                              avatarUrl.startsWith('http') ||
                              avatarUrl.startsWith('blob:')) {
                            avatarImage = NetworkImage(avatarUrl);
                          } else {
                            final f = File(avatarUrl);
                            if (f.existsSync()) {
                              avatarImage = FileImage(f);
                            }
                          }
                        }

                        return Tooltip(
                          message: 'Profil',
                          child: Material(
                            color: Color(0xFFE0E0E0),
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SellerProfilePage(isOwnProfile: true),
                                  ),
                                );
                              },
                              splashColor: AppColors.charcoal.withAlpha(55),
                              highlightColor: AppColors.charcoal.withAlpha(50),
                              hoverColor: AppColors.charcoal.withAlpha(25),
                              child: SizedBox(
                                width: 34,
                                height: 34,
                                child: avatarImage != null
                                    ? Ink.image(
                                        image: avatarImage,
                                        fit: BoxFit.cover,
                                        width: 34,
                                        height: 34,
                                      )
                                    : const Center(
                                        child: WIcon(
                                          Icons.person,
                                          size: 19,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
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
                    CategoryManageScreen(),
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
            color: Color(0xFFE0E0E0),
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
