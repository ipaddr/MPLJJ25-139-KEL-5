import 'package:flutter/material.dart';
import 'notif_ajukan.dart'; // Import halaman notifikasi pengajuan
import 'beranda.dart'; // Asumsi Beranda ada untuk navigasi kembali dari header

class PengajuanSekolahPage extends StatelessWidget {
  const PengajuanSekolahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // CustomHeader (pastikan ini diimpor atau didefinisikan di sini jika tidak diimpor)
            const CustomHeader(),

            // Tombol back & Judul
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed:
                        () => Navigator.pop(
                          context,
                        ), // Kembali ke halaman sebelumnya
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pengajuan\nSekolah Belum Terdaftar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Form Input
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(label: 'Nama Sekolah'),
                    CustomTextField(label: 'Alamat Sekolah'),
                    CustomTextField(label: 'Nama Kontak'),
                    CustomTextField(label: 'No Telepon'),
                    CustomTextField(label: 'Email'),
                    const SizedBox(height: 24),

                    // Tombol Kirim
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Tambahkan logika pengajuan yang sebenarnya di sini.
                          // Misalnya, validasi input, simpan data ke database, dll.

                          // Setelah pengajuan (dummy) berhasil:
                          // Navigasi ke NotifPengajuanPage dan hapus semua rute sebelumnya
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const NotifAjukanPage(),
                            ),
                            (Route<dynamic> route) =>
                                false, // Hapus semua rute dari stack
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 21, 6, 87),
                          foregroundColor:
                              Colors.white, // Menambahkan warna teks putih
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Kirim'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomHeader (Jika belum ada di file terpisah dan diimpor, sertakan di sini)
// Jika CustomHeader sudah diimpor dari file lain, Anda bisa menghapus definisi ini.
class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2378),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.book,
            color: Colors.white,
          ), // Atau Image.asset('assets/logo.png')
          const SizedBox(width: 8),
          const Text(
            'Farastika Allistio\nLaper\'in Catering',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              // Contoh navigasi ke Beranda dari header
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Beranda()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // TODO: Navigasi ke halaman Menu
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPage()));
            },
          ),
        ],
      ),
    );
  }
}

// CustomTextField (Jika belum ada di file terpisah dan diimpor, sertakan di sini)
// Jika CustomTextField sudah diimpor dari file lain, Anda bisa menghapus definisi ini.
class CustomTextField extends StatelessWidget {
  final String label;
  const CustomTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.grey.shade300,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
