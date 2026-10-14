import 'package:flutter/material.dart';

import '../../controllers/AuthController.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Membuka Pop-up Modal "Masuk ke RePake" (Google Sign-In UNSIKA).
/// Mengembalikan `true` jika user berhasil masuk.
Future<bool?> showLoginPopup(
  BuildContext context, {
  VoidCallback? onSuccess,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => LoginPopupDialog(onSuccess: onSuccess),
  );
}

/// Dialog Pop-up Login RePake.
/// nyoba jadi kontributor
/// Mengikuti 2 tahap:
/// 1. Tampilan awal persis sesuai wireframe PDF (Logo, Teks, tombol "Continue with Google").
/// 2. Setelah tombol "Continue with Google" ditekan, barulah muncul layar
///    pilihan akun Google SSO UNSIKA (Akun User Mahasiswa vs Akun Admin).
class LoginPopupDialog extends StatefulWidget {
  const LoginPopupDialog({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  State<LoginPopupDialog> createState() => _LoginPopupDialogState();
}

class _LoginPopupDialogState extends State<LoginPopupDialog> {
  bool _isLoading = false;
  bool _showAccountChooser = false;
  String? _loadingAccountId;

  Future<void> _performSignIn({
    required bool isAdmin,
    required String name,
    required String email,
  }) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _loadingAccountId = isAdmin ? 'admin' : 'user';
    });

    // Simulasi jeda autentikasi SSO Google UNSIKA
    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;

    if (isAdmin) {
      AuthController.instance.loginAsAdmin(name: name, email: email);
    } else {
      AuthController.instance.loginAsUser(name: name, email: email);
    }

    widget.onSuccess?.call();

    Navigator.of(context).pop(true);

    final roleLabel = isAdmin
        ? 'Admin RePake (Administrator)'
        : 'Midou_kun (Mahasiswa UNSIKA)';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.lime, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Berhasil masuk sebagai $roleLabel!',
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neutral900.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: _showAccountChooser
                  ? _buildAccountChooserView()
                  : _buildInitialView(),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAMPILAN 1: WIREFRAME UTAMA ("Masuk ke RePake")
  // ---------------------------------------------------------------------------
  Widget _buildInitialView() {
    return Column(
      key: const ValueKey('initial_view'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Tombol Close (X) di kanan atas
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.close_rounded,
              size: 24,
              color: AppColors.neutral700,
            ),
            onPressed: () => Navigator.of(context).pop(false),
            tooltip: 'Tutup',
          ),
        ),

        const SizedBox(height: 4),

        // 2. Logo RePake (Rounded Lime Box)
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.lime,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/repake_logo.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(
                Icons.recycling_rounded,
                size: 42,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 3. Judul "Masuk ke RePake"
        Text(
          'Masuk ke RePake',
          style: AppTextStyles.h3().copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 23,
            color: AppColors.charcoal,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 10),

        // 4. Subtitle Akun Google UNSIKA
        Text(
          'Silahkan masuk menggunakan\nakun Google UNSIKA anda\nuntuk mulai menjelajahi RePake',
          textAlign: TextAlign.center,
          style: AppTextStyles.body().copyWith(
            color: AppColors.neutral700,
            fontSize: 14,
            height: 1.45,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 28),

        // 5. Tombol "Continue with Google" -> Saat ditekan, lanjut ke pemilihan akun
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surfaceElevated,
              foregroundColor: AppColors.charcoal,
              elevation: 0,
              side: const BorderSide(
                color: AppColors.neutral300,
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              setState(() => _showAccountChooser = true);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _GoogleLogoG(size: 22),
                const SizedBox(width: 12),
                Text(
                  'Continue with Google',
                  style: AppTextStyles.label().copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 6. Syarat & Ketentuan RePake
        Text(
          'Dengan masuk, Anda menyetujui\nSyarat dan Ketentuan RePake',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption().copyWith(
            color: AppColors.neutral500,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAMPILAN 2: PILIHAN AKUN GOOGLE UNSIKA (User vs Admin)
  // ---------------------------------------------------------------------------
  Widget _buildAccountChooserView() {
    return Column(
      key: const ValueKey('account_chooser_view'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bar Navigasi Atas: Kembali (<-) dan Tutup (X)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 22,
                color: AppColors.charcoal,
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() => _showAccountChooser = false);
                    },
              tooltip: 'Kembali',
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
                color: AppColors.neutral700,
              ),
              onPressed: () => Navigator.of(context).pop(false),
              tooltip: 'Tutup',
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Header Google SSO
        Row(
          children: [
            const _GoogleLogoG(size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih akun Google',
                    style: AppTextStyles.h4().copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: AppColors.charcoal,
                    ),
                  ),
                  Text(
                    'untuk melanjutkan ke RePake UNSIKA',
                    style: AppTextStyles.body().copyWith(
                      fontSize: 12,
                      color: AppColors.neutral600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        const Divider(height: 1, color: AppColors.neutral200),
        const SizedBox(height: 4),

        // Pilihan Akun 1: User (Mahasiswa UNSIKA)
        _buildAccountItem(
          id: 'user',
          name: 'Midou_kun',
          email: 'midou.kun@student.unsika.ac.id',
          avatarInitial: 'M',
          avatarBgColor: AppColors.lime400,
          avatarTextColor: AppColors.charcoal,
          roleBadge: 'Mahasiswa (User)',
          roleBadgeBg: AppColors.lime100,
          roleBadgeColor: AppColors.lime900,
          onTap: () => _performSignIn(
            isAdmin: false,
            name: 'Midou_kun',
            email: 'midou.kun@student.unsika.ac.id',
          ),
        ),

        const Divider(height: 1, color: AppColors.neutral200),

        // Pilihan Akun 2: Admin (Administrator RePake)
        _buildAccountItem(
          id: 'admin',
          name: 'Admin RePake',
          email: 'admin@unsika.ac.id',
          avatarInitial: 'A',
          avatarBgColor: AppColors.charcoal,
          avatarTextColor: AppColors.textOnDark,
          roleBadge: 'Administrator (Admin)',
          roleBadgeBg: AppColors.neutral100,
          roleBadgeColor: AppColors.charcoal,
          onTap: () => _performSignIn(
            isAdmin: true,
            name: 'Admin RePake',
            email: 'admin@unsika.ac.id',
          ),
        ),

        const Divider(height: 1, color: AppColors.neutral200),

        const SizedBox(height: 16),

        // Catatan Privasi Google
        Text(
          'Untuk melanjutkan, Google akan membagikan nama, alamat email, dan preferensi bahasa Anda kepada RePake.',
          style: AppTextStyles.caption().copyWith(
            fontSize: 11.5,
            color: AppColors.neutral500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountItem({
    required String id,
    required String name,
    required String email,
    required String avatarInitial,
    required Color avatarBgColor,
    required Color avatarTextColor,
    required String roleBadge,
    required Color roleBadgeBg,
    required Color roleBadgeColor,
    required VoidCallback onTap,
  }) {
    final isThisLoading = _isLoading && _loadingAccountId == id;

    return InkWell(
      onTap: _isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: avatarBgColor,
              child: Text(
                avatarInitial,
                style: AppTextStyles.label().copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: avatarTextColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label().copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: roleBadgeBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          roleBadge,
                          style: AppTextStyles.smallLabel().copyWith(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: roleBadgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: AppTextStyles.caption().copyWith(
                      fontSize: 12,
                      color: AppColors.neutral600,
                    ),
                  ),
                ],
              ),
            ),
            if (isThisLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.charcoal),
                ),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.neutral400,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

/// Logo 'G' Google dengan 4 warna khas: Biru, Merah, Kuning, Hijau
class _GoogleLogoG extends StatelessWidget {
  const _GoogleLogoG({this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/512px-Google_%22G%22_logo.svg.png',
      width: size,
      height: size,
      errorBuilder: (_, __, ___) => CustomPaint(
        size: Size(size, size),
        painter: _GooglePainter(),
      ),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintBlue = Paint()
      ..color = AppColors.googleBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final paintRed = Paint()
      ..color = AppColors.googleRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final paintYellow = Paint()
      ..color = AppColors.googleYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final paintGreen = Paint()
      ..color = AppColors.googleGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final rect = Rect.fromCircle(center: center, radius: radius - 2);

    canvas.drawArc(rect, -0.8, 1.2, false, paintBlue);
    canvas.drawArc(rect, 0.4, 1.2, false, paintGreen);
    canvas.drawArc(rect, 1.6, 1.2, false, paintYellow);
    canvas.drawArc(rect, 2.8, 1.2, false, paintRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
