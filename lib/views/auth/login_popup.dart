// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() => runApp(RePakeApp());

class RePakeApp extends StatelessWidget {
  const RePakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema Hijau RePake
    const Color repakeGreen = Color(0xFFC3E06D);
    const Color repakeBackground = Color(0xFFF9F9F4);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RePake',
      theme: ThemeData(
        primaryColor: repakeGreen,
        scaffoldBackgroundColor: repakeBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: repakeGreen,
          primary: repakeGreen,
        ),
      ),
      home: GuestLandingPage(), // Menggunakan Landing Page sebagai dasar
    );
  }
}

// ==========================================
// HALAMAN LANDING PAGE (GUEST)
// ==========================================
class GuestLandingPage extends StatelessWidget {
  const GuestLandingPage({super.key});

  // Fungsi untuk memunculkan UI Pop-up Login
  void _showLoginPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Bisa ditutup dengan tap di luar pop-up
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Pop-up menyesuaikan tinggi konten
              children: [
                // Tombol Close (X) di pojok kanan
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),

                // Judul Pop-up
                Text(
                  'Masuk ke RePake',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Silakan masuk dengan akun Google',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30),

                // Tombol Sign in with Google
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Masukkan fungsi Autentikasi Google Firebase di sini
                      print("Sign in with Google ditekan");
                    },
                    // Menggunakan Logo Google dari internet
                    icon: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                      height: 24,
                    ),
                    label: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Nama Web', // Sesuai dengan wireframe di kiri atas
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Tombol Masuk di Header (seperti di wireframe)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () => _showLoginPopup(context),
              child: Text(
                'Masuk',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Tombol +Jual (Hanya ilustrasi Header)
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10, bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC3E06D),
                foregroundColor: Colors.black87,
                elevation: 0,
              ),
              onPressed: () {},
              child: Text('+Jual'),
            ),
          )
        ],
      ),
      body: Center(
        child: Text(
          'Ini halaman Landing Page.\nCoba klik tombol "Masuk" di pojok kanan atas.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
