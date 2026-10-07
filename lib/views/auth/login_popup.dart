// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:projectrepake/main.dart';// Diperlukan agar bisa kembali ke halaman Login

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color repakeGreen = Color(0xFFC3E06D);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard RePake',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: repakeGreen,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon Sukses
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: repakeGreen,
            ),
            SizedBox(height: 20),
            Text(
              'Login Berhasil!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ini adalah tampilan Dashboard sementara.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40),

            // Tombol Logout untuk kembali ke halaman Login
            SizedBox(
              width: 200,
              height: 45,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Fungsi navigasi kembali ke halaman Login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyApp(), // Memanggil class LoginApp dari main.dart
                    ),
                  );
                },
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
