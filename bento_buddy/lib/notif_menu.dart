import 'package:flutter/material.dart';
// Asumsi 'upload_menu_page.dart' adalah nama file yang benar
// Jika file Anda bernama 'upload_menu.dart', harap sesuaikan import ini.
import 'upload_menu.dart'; // Import halaman upload menu jika diperlukan
import 'menu_hari_ini.dart'; // Import halaman MenuHariIni Anda

class NotifMenuPage extends StatelessWidget {
  const NotifMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Pusatkan konten secara vertikal
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2378), // Warna biru tua
                borderRadius: BorderRadius.circular(20), // Sudut membulat
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Sesuaikan ukuran kolom dengan kontennya
                children: [
                  // Gambar ikon centang dari aset
                  Image.asset(
                    'assets/check_icon.png', // Path aset ikon centang Anda
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
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Berhasil DiUpload',
                    style: TextStyle(
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
            // Tombol "Lihat Menu"
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman MenuHariIni dan hapus semua rute sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MenuHariIni()),
                  (Route<dynamic> route) =>
                      false, // Menghapus semua rute dari stack
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2378), // Warna biru tua
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
                'Lihat Menu', // Teks tombol
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
