import 'package:flutter/foundation.dart';

import '../models/UserRole.dart';

/// Menyimpan peran (role) pengguna yang sedang aktif.
///
/// SEKARANG masih dummy karena belum ada database / login.
/// Nanti, setelah login berhasil, isi [role] sesuai data akun, contoh:
///   AuthController.instance.role.value = UserRole.admin;
///
/// Kalau kamu sudah punya auth_controller.dart sendiri, cukup ambil
/// bagian `role`-nya saja.
class AuthController {
  AuthController._();

  /// Satu-satunya instance (singleton), diakses lewat AuthController.instance.
  static final AuthController instance = AuthController._();

  /// ValueNotifier = nilai yang bisa "didengarkan". Saat nilainya berubah,
  /// main.dart otomatis mengganti tampilan (UserNavbar <-> AdminNavbar).
  final ValueNotifier<UserRole> role = ValueNotifier(UserRole.admin);

  /// KHUSUS TESTING: tukar user <-> admin tanpa login.
  /// HAPUS fungsi ini kalau login asli sudah jadi.
  void toggleDevRole() {
    role.value = role.value == UserRole.admin ? UserRole.user : UserRole.admin;
  }
}
