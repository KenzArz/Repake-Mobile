import 'package:flutter/material.dart';

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
    return ValueListenableBuilder<UserRole>(
      valueListenable: AuthController.instance.role,
      builder: (context, role, _) {
        final homeScreen =
            role == UserRole.admin ? const AdminNavbar() : const UserNavbar();

        return Stack(
          children: [
            // Home screen (rebuild when role changes)
            if (!_showSplash)
              FadeTransition(
                opacity: _fadeAnimation,
                child: homeScreen,
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
      },
    );
  }
}
