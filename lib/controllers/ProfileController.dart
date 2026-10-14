import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

import '../models/UserModel.dart';

/// Controller untuk Mengelola Profil & Form Edit Profil Pengguna (MVC Architecture).
class ProfileController extends ChangeNotifier {
  ProfileController({UserModel? initialUser}) {
    _currentUser = initialUser ?? UserModel.defaultUser();
    _initControllers();
  }

  static final ProfileController instance = ProfileController();

  late UserModel _currentUser;
  File? _avatarFile;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController locationController;
  late final TextEditingController bioController;

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  UserModel get currentUser => _currentUser;
  File? get avatarFile => _avatarFile;
  bool get isLoading => _isLoading;
  String? get currentAvatarUrl => _currentUser.avatarUrl;

  // ---------------------------------------------------------------------------
  // INITIALIZATION & SYNC
  // ---------------------------------------------------------------------------

  void _initControllers() {
    nameController = TextEditingController(text: _currentUser.name);
    emailController = TextEditingController(text: _currentUser.email);
    phoneController = TextEditingController(text: _currentUser.phone);
    locationController = TextEditingController(text: _currentUser.location);
    bioController = TextEditingController(text: _currentUser.bio);
  }

  /// Sinkronkan form controllers dengan data user terkini
  void syncControllersWithUser() {
    nameController.text = _currentUser.name;
    emailController.text = _currentUser.email;
    phoneController.text = _currentUser.phone;
    locationController.text = _currentUser.location;
    bioController.text = _currentUser.bio;

    if (!kIsWeb &&
        _currentUser.avatarUrl != null &&
        _currentUser.avatarUrl!.isNotEmpty) {
      final file = File(_currentUser.avatarUrl!);
      if (file.existsSync()) {
        _avatarFile = file;
      }
    }

    // OPSI A: Defer notifyListeners sampai frame selesai build
    // Ini mencegah "setState during build" error
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Update data user secara langsung dan sinkronkan form
  void updateUser(UserModel user) {
    _currentUser = user;
    syncControllersWithUser();
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------

  /// Memilih foto profil dari galeri atau kamera
  Future<void> pickAvatar(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (picked != null) {
        if (!kIsWeb) {
          _avatarFile = File(picked.path);
        }
        _currentUser = _currentUser.copyWith(avatarUrl: picked.path);

        // Defer notifyListeners untuk avoid "setState during build"
        SchedulerBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    } catch (e) {
      debugPrint('Error picking avatar: $e');
    }
  }

  /// Menghapus foto profil saat ini
  void removeAvatar() {
    _avatarFile = null;
    _currentUser = _currentUser.copyWith(avatarUrl: '');

    // Defer notifyListeners untuk avoid "setState during build"
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Menyimpan perubahan form profil
  /// Mengembalikan pesan sukses jika berhasil, atau pesan error jika validasi gagal
  Future<String?> saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final location = locationController.text.trim();
    final bio = bioController.text.trim();

    // Validasi form
    if (name.isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    }

    if (email.isNotEmpty && !email.contains('@')) {
      return 'Format email tidak valid';
    }

    _isLoading = true;

    // Defer notifyListeners untuk avoid "setState during build"
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    // Simulasi jeda simpan
    await Future.delayed(const Duration(milliseconds: 300));

    String? updatedAvatarUrl;
    if (_avatarFile != null) {
      updatedAvatarUrl = _avatarFile!.path;
    } else if (_currentUser.avatarUrl != null &&
        _currentUser.avatarUrl!.isNotEmpty) {
      updatedAvatarUrl = _currentUser.avatarUrl;
    } else {
      updatedAvatarUrl = '';
    }

    _currentUser = _currentUser.copyWith(
      name: name,
      email: email,
      phone: phone,
      location: location,
      bio: bio,
      avatarUrl: updatedAvatarUrl,
    );

    _isLoading = false;

    // Defer notifyListeners untuk avoid "setState during build"
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    return 'Profil berhasil diperbarui!';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
