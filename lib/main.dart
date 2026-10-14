import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'controllers/AuthController.dart';
import 'models/UserRole.dart';
import 'theme/app_theme.dart';
import 'views/navigation/admin_navbar.dart';
import 'views/navigation/user_navbar.dart';
import 'views/splash/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const _AppWrapper(),
    );
  }
}

/// Pre-building approach untuk zero stuck transition.
/// Trade-off: Sedikit lebih banyak memory usage untuk UX yang sempurna.
class _AppWrapper extends StatefulWidget {
  const _AppWrapper();

  @override
  State<_AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<_AppWrapper>
    with TickerProviderStateMixin {
  bool _showSplash = true;
  Widget? _prebuiltHome;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Pre-build home screen di background
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _preBuildHomeScreen();
    });
  }

  void _preBuildHomeScreen() {
    if (!mounted) return;

    final role = AuthController.instance.role.value;
    _prebuiltHome =
        role == UserRole.admin ? const AdminNavbar() : const UserNavbar();

    setState(() {
      // Trigger offscreen build
    });
  }

  void _onSplashComplete() {
    if (!mounted) return;

    setState(() {
      _showSplash = false;
    });

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Home screen pre-rendered (opacity 0 saat splash)
        if (_prebuiltHome != null)
          Opacity(
            opacity: _showSplash ? 0.0 : 1.0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _prebuiltHome!,
            ),
          ),

        // Splash screen fade out
        if (_showSplash)
          FadeTransition(
            opacity:
                Tween<double>(begin: 1.0, end: 0.0).animate(_fadeAnimation),
            child: SplashScreen(
              key: const ValueKey('splash'),
              onComplete: _onSplashComplete,
            ),
          ),
      ],
    );
  }
}
