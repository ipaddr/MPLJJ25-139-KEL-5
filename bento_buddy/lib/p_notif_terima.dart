import 'package:flutter/material.dart';
import 'p_sekolah.dart'; // Import halaman Beranda untuk navigasi setelah notifikasi pengajuan
// Asumsi halaman pengajuan yang memanggil notifikasi ini adalah pengajuanpage.dart
// Tidak perlu mengimpor 'upload_menu.dart' atau 'menu_hari_ini.dart' di sini.

class PNotifterima extends StatelessWidget {
  const PNotifterima({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang putih
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
                    'assets/check_icon.png', // Pastikan aset ikon centang ada
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback ikon jika aset tidak ditemukan
                      return const Icon(
                        Icons.check_circle_outline, // Ikon centang fallback
                        color: Colors.greenAccent, // Warna hijau terang
                        size: 80,
                      );
                    },
                  ),
                  const SizedBox(height: 20), // Spasi vertikal
                  const Text(
                    'Pengajuan', // Teks notifikasi
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Berhasil Diterima', // Teks notifikasi
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
            // Tombol "Kembali ke Beranda"
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman Beranda dan hapus semua rute sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const PDataSekolahPage(),
                  ),
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
                'Lihat', // Teks tombol
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
