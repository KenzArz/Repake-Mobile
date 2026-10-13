import 'package:flutter/material.dart';

import 'controllers/AuthController.dart';
import 'models/UserRole.dart';
import 'theme/app_theme.dart';
import 'views/navigation/admin_navbar.dart';
import 'views/navigation/user_navbar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      // ValueListenableBuilder "mendengarkan" perubahan role. Setiap role
      // berubah (login / logout / toggle), bagian ini otomatis dibangun ulang
      // dan menampilkan navbar yang sesuai.
      home: ValueListenableBuilder<UserRole>(
        valueListenable: AuthController.instance.role,
        builder: (context, role, _) {
          return role == UserRole.admin
              ? const AdminNavbar()
              : const UserNavbar(); // user & guest memakai navbar yang sama
        },
      ),
    );
  }
}