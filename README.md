# RePake Mobile

RePake adalah aplikasi Flutter untuk jual beli barang bekas di lingkungan
mahasiswa. Aplikasi ini menyediakan alur penjelajahan produk, favorit, unggah
produk, percakapan penjual-pembeli, serta fitur administrasi sederhana.

> **Status proyek:** aplikasi saat ini merupakan prototipe UI/fungsional untuk
> demonstrasi. Login mahasiswa dan admin disimulasikan, dan beberapa data
> produk, favorit, serta interaksi masih berupa data dummy lokal. Belum ada
> integrasi autentikasi Google atau backend/database.

## Fitur

- Beranda untuk melihat dan mencari produk serta menjelajahi kategori/banner.
- Detail produk, informasi penjual, produk serupa, dan formulir penawaran.
- Favorit, tambah produk, profil penjual, dan edit profil.
- Halaman daftar chat, ruang chat, dan komponen penawaran.
- Pemisahan alur Guest, User/Mahasiswa, dan Admin.
- Dashboard admin untuk mengelola kategori, banner, dan laporan.
- Splash screen animasi menggunakan Lottie.
- Pemilihan foto profil/produk melalui kamera atau galeri menggunakan
  `image_picker`.
- Sistem tema bersama untuk warna dan tipografi.

## Teknologi

- Flutter dengan Dart SDK `^3.0.0` (Dart 3 atau lebih baru).
- Material 3.
- `google_fonts` untuk tipografi Bricolage Grotesque dan Manrope.
- `image_picker` untuk memilih gambar.
- `lottie` untuk animasi splash.

## Persyaratan

Pasang Flutter SDK dan siapkan setidaknya satu target untuk menjalankan aplikasi,
misalnya emulator/perangkat Android, simulator iOS di macOS, atau browser.
Pastikan perintah berikut tersedia di terminal:

```bash
flutter --version
flutter doctor
```

Untuk menjalankan target Android, siapkan Android SDK dan emulator atau perangkat
fisik. Pembuatan aplikasi iOS membutuhkan macOS dan Xcode.

## Instalasi dan menjalankan

1. Clone repositori dan masuk ke folder proyek:

   ```bash
   git clone <URL_REPOSITORY>
   cd Repake-Mobile
   ```

2. Unduh dependensi:

   ```bash
   flutter pub get
   ```

3. Lihat perangkat/target yang tersedia:

   ```bash
   flutter devices
   ```

4. Jalankan aplikasi:

   ```bash
   flutter run
   ```

   Untuk memilih target tertentu:

   ```bash
   flutter run -d <device-id>
   ```

## Pengujian dan pemeriksaan

Jalankan seluruh unit/widget test yang tersedia:

```bash
flutter test
```

Jalankan pemeriksaan statis:

```bash
flutter analyze
```

## Build

Contoh perintah build:

```bash
flutter build apk
flutter build appbundle
flutter build web
```

Build iOS dilakukan di macOS:

```bash
flutter build ios
```

## Struktur folder

```text
.
├── android/                  # Konfigurasi dan proyek native Android
├── assets/
│   ├── animations/           # Animasi Lottie, termasuk splash.json
│   └── images/               # Gambar lokal, termasuk logo RePake
├── ios/                      # Konfigurasi dan proyek native iOS
├── lib/
│   ├── controllers/          # Logika state dan aksi fitur
│   ├── models/               # Model data produk, user, chat, laporan, dll.
│   ├── theme/                # AppColors, AppTextStyles, dan AppTheme
│   ├── utils/                # Helper umum, misalnya navigasi
│   ├── views/
│   │   ├── admin/            # Dashboard dan pengelolaan admin
│   │   ├── auth/             # Dialog/alur login
│   │   ├── chat/             # Daftar chat, ruang chat, dan widget
│   │   ├── favorite/         # Halaman produk favorit
│   │   ├── home/             # Beranda dan widget beranda
│   │   ├── navigation/       # Shell serta navigasi User/Admin
│   │   ├── product/          # Tambah produk, detail, dan widget produk
│   │   ├── profile/          # Profil penjual dan edit profil
│   │   └── splash/           # Layar pembuka
│   └── main.dart             # Entry point dan konfigurasi aplikasi
├── linux/                    # Konfigurasi target Linux
├── web/                      # Konfigurasi target web
├── pubspec.yaml              # Metadata proyek, dependensi, dan deklarasi aset
└── analysis_options.yaml     # Konfigurasi analisis/lint Dart
```

## Arsitektur dan alur aplikasi

Kode aplikasi berada di `lib/` dan secara umum memisahkan model, controller,
serta view:

- **Models** mendefinisikan bentuk data yang digunakan UI.
- **Controllers** mengelola state dan aksi. Contohnya `AuthController` untuk
  role pengguna, `ProductController` untuk data produk, dan controller lain
  untuk profil/chat/detail produk.
- **Views** menyusun halaman dan widget berdasarkan fitur.
- **Theme** menyediakan palet warna terpusat di `AppColors`, gaya teks di
  `AppTextStyles`, dan konfigurasi tema di `AppTheme`.

`main.dart` menampilkan splash screen lalu memilih navigasi berdasarkan role.
Navigasi Guest/User menyediakan tab Home, Favorite, Jual, dan Chat; navigasi
Admin menambahkan Dashboard. Akses Guest ke fitur terbatas akan meminta login.

Login yang tersedia hanya simulasi untuk membantu demonstrasi alur User dan
Admin. Kredensial demo ditampilkan di dialog pemilihan akun dalam aplikasi;
tidak ada proses verifikasi akun atau penyimpanan sesi ke server.

## Aset

Aset lokal dideklarasikan di `pubspec.yaml`:

- `assets/animations/` untuk animasi.
- `assets/images/` untuk gambar lokal.

Beberapa gambar konten demo dapat menggunakan URL eksternal. Pastikan koneksi
internet tersedia untuk memuat konten tersebut. Font dari `google_fonts` juga
dapat memerlukan akses internet jika belum tersedia di cache perangkat.

## Catatan pengembangan

- Data dan autentikasi saat ini belum persisten; perubahan dapat hilang ketika
  aplikasi dimulai ulang.
- Sebelum rilis produksi, hubungkan autentikasi, data produk, chat, favorit, dan
  laporan ke backend yang sesuai.
- Periksa konfigurasi izin kamera/galeri dan kebijakan privasi pada setiap
  platform sebelum distribusi.
- Setelah mengubah dependensi atau deklarasi aset, jalankan `flutter pub get`.

## Kontribusi

1. Buat branch untuk perubahan yang dikerjakan.
2. Ikuti pola struktur serta tema yang sudah digunakan.
3. Jalankan `dart format` pada file Dart yang diubah, kemudian `flutter analyze`
   dan test yang relevan.
4. Ajukan perubahan melalui pull request dengan ringkasan dan langkah
   verifikasi.
