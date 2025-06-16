import 'package:flutter/material.dart';
import 'login_page.dart'; // Import halaman login Anda. Pastikan nama filenya benar.

class NotifRegisterPage extends StatelessWidget {
  const NotifRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih sesuai gambar
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Pusatkan konten secara vertikal
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2378), // Warna biru tua sesuai gambar
                borderRadius: BorderRadius.circular(20), // Sudut membulat
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Sesuaikan ukuran kolom dengan kontennya
                children: [
                  // Gambar ikon centang dari aset
                  Image.asset(
                    'assets/check_icon.png', // Path aset ikon centang Anda [Image of Check Icon]
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback ikon jika aset tidak ditemukan
                      return const Icon(
                        Icons.check_circle_outline, // Fallback ikon centang
                        color: Colors.greenAccent, // Warna hijau terang
                        size: 80,
                      );
                    },
                  ),
                  const SizedBox(height: 20), // Spasi vertikal
                  const Text(
                    'Akun', // Teks 'Akun' [Image of Akun]
                    style: TextStyle(
                      // Perbaikan: TextStyle lengkap
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Berhasil Dibuat', // Teks 'Berhasil Dibuat' [Image of Berhasil Dibuat]
                    style: TextStyle(
                      // Perbaikan: TextStyle lengkap
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ), // Spasi vertikal antara kotak notifikasi dan tombol
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman login dan hapus semua rute sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) =>
                      false, // Menghapus semua rute dari stack
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF1E2378,
                ), // Warna biru tua sesuai gambar
                foregroundColor: Colors.white, // Warna teks tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Sudut membulat pada tombol
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ), // Padding tombol
              ),
              child: const Text(
                'Login', // Teks tombol 'Login' [Image of Login Button]
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ), // Gaya teks tombol
              ),
            ),
          ],
        ),
      ),
    );
  }
}
