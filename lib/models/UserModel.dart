/// Model data pengguna / profil di aplikasi RePake (MVC Architecture - Model Layer).
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    this.bio = '',
    this.avatarUrl,
    this.rating = 4.5,
    this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String bio;
  final String? avatarUrl;
  final double rating;
  final DateTime? createdAt;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? bio,
    String? avatarUrl,
    double? rating,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl != null
          ? (avatarUrl.isEmpty ? null : avatarUrl)
          : this.avatarUrl,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Data dummy default pengguna (User Mahasiswa)
  static UserModel defaultUser() {
    return UserModel(
      id: 'usr_001',
      name: 'Midou_kun',
      email: 'midou.kun@student.unsika.ac.id',
      phone: '0812-3456-7890',
      location: 'Bekasi',
      bio: 'Sedia perifer PC & setup mechanical keyboard bekas berkualitas.',
      avatarUrl: null,
      rating: 4.5,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );
  }

  /// Data dummy default akun Administrator
  static UserModel defaultAdmin() {
    return UserModel(
      id: 'adm_001',
      name: 'Admin RePake',
      email: 'admin@unsika.ac.id',
      phone: '0811-9876-5432',
      location: 'Karawang (UNSIKA)',
      bio: 'Administrator Resmi RePake UNSIKA. Mengelola laporan, verifikasi banner, dan kategori produk.',
      avatarUrl: null,
      rating: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    );
  }
}

