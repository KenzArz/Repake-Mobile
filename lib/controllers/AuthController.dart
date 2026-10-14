import 'package:flutter/foundation.dart';

import '../models/UserModel.dart';
import '../models/UserRole.dart';
import 'ProfileController.dart';

/// Controller Autentikasi & Manajemen Peran Pengguna (MVC Architecture).
///
/// Mendukung 3 peran:
/// - [UserRole.guest]: Tamu yang belum masuk (hanya bisa melihat barang)
/// - [UserRole.user]: Mahasiswa yang sudah masuk dengan Google UNSIKA
/// - [UserRole.admin]: Administrator sistem
class AuthController {
  AuthController._();

  /// Singleton instance
  static final AuthController instance = AuthController._();

  /// Role pengguna saat ini. Dimulai dari [UserRole.guest] agar alur
  /// login pop-up dan perbedaan fitur 2 aktor (guest & user) dapat langsung diuji.
  final ValueNotifier<UserRole> role = ValueNotifier<UserRole>(UserRole.guest);

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  bool get isGuest => role.value == UserRole.guest;
  bool get isUser => role.value == UserRole.user;
  bool get isAdmin => role.value == UserRole.admin;

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------

  /// Masuk sebagai Mahasiswa UNSIKA menggunakan akun Google (Dummy User)
  void loginAsUser({
    String name = 'Midou_kun',
    String email = 'midou.kun@student.unsika.ac.id',
  }) {
    role.value = UserRole.user;
    ProfileController.instance.updateUser(
      UserModel.defaultUser().copyWith(
        name: name,
        email: email,
      ),
    );
  }

  /// Masuk sebagai Administrator RePake menggunakan akun Google (Dummy Admin)
  void loginAsAdmin({
    String name = 'Admin RePake',
    String email = 'admin@unsika.ac.id',
  }) {
    role.value = UserRole.admin;
    ProfileController.instance.updateUser(
      UserModel.defaultAdmin().copyWith(
        name: name,
        email: email,
      ),
    );
  }

  /// Keluar dari akun (Log Out), mengubah peran kembali menjadi [UserRole.guest]
  void logout() {
    role.value = UserRole.guest;
  }

  /// Mengubah peran secara langsung (berguna untuk testing dev)
  void setRole(UserRole newRole) {
    role.value = newRole;
  }

  /// Siklus peran: Guest -> User -> Admin -> Guest
  void toggleDevRole() {
    if (role.value == UserRole.guest) {
      role.value = UserRole.user;
    } else if (role.value == UserRole.user) {
      role.value = UserRole.admin;
    } else {
      role.value = UserRole.guest;
    }
  }
}
