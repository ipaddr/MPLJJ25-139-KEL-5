import 'package:flutter/material.dart';
// Import halaman-halaman tujuan
import 'nerimabantuan.dart'; // Sudah benar
import 'blmnerimabantuan.dart';
import 'jasa_catering.dart';
import 'pengajuanpage.dart'; // asumsi ada PengajuanSekolahPage
import 'laporan.dart'; // asumsi ada LaporanPage
import 'profil.dart'; // asumsi ada ProfilPage

// Import CustomHeader dari beranda.dart (atau lokasi aslinya jika sudah terpisah)
// Agar CustomHeader konsisten di seluruh aplikasi, idealnya ditempatkan di file terpisah
// yang dapat diimpor oleh semua halaman. Untuk saat ini, saya akan mengimpornya.
// Jika CustomHeader belum terpisah, pastikan Anda memisahkan CustomHeader dari beranda.dart
// ke file baru (misalnya custom_header.dart) dan import di sini.
// Untuk tujuan ini, saya akan menggunakan nama CustomHeaderApp sebagai pembeda
// jika ada CustomHeader lain di proyek Anda.
import 'beranda.dart'; // Mengimpor CustomHeaderBeranda dari beranda.dart (asumsi nama CustomHeader di beranda.dart adalah CustomHeaderBeranda)

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1464),
        toolbarHeight: 80,
        title: Row(
          children: [
            const Icon(
              Icons.school,
              size: 32,
              color: Colors.white,
            ), // Atau Image.asset('assets/logo.png', width: 32, height: 32)
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Farastika Allistio",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "Laper'in Cathering",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            // Ikon menu di Menu AppBar juga harusnya tidak navigasi kemana-mana atau pop
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Di halaman menu, menekan ikon menu bisa jadi untuk menutup menu
                // atau tidak melakukan apa-apa.
                // Jika menu ini adalah root dari navigasi, Anda mungkin ingin pop.
                // Jika ini adalah halaman yang bisa diakses dari berbagai tempat,
                // maka Navigator.pop() akan membawa kembali ke halaman sebelumnya.
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Mau cari apa?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                children: [
                  _buildMenuItem(
                    context,
                    'assets/menerima.png', // Pastikan aset ini ada
                    'Menerima Bantuan',
                    const DataSekolahPage(), // Navigasi ke DataSekolahPage
                  ),
                  _buildMenuItem(
                    context,
                    'assets/belum_menerima.png', // Pastikan aset ini ada
                    'Belum Menerima Bantuan',
                    const Blmnerimabantuan(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/cathering.png', // Pastikan aset ini ada
                    'Cathering',
                    const JasaCateringPage(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/ajukan.png', // Pastikan aset ini ada
                    'Ajukan Sekolah',
                    // Pastikan PengajuanSekolahPage ada di pengajuanpage.dart
                    const PengajuanSekolahPage(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/laporan.png', // Pastikan aset ini ada
                    'Laporan',
                    // Pastikan LaporanPage ada di laporan.dart
                    const LaporanPage(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/profil.png', // Pastikan aset ini ada
                    'Profil',
                    // Pastikan ProfilPage ada di profil.dart
                    const ProfilPage(),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke halaman sebelumnya
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1464),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Kembali'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: implement logout logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout ditekan!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1464),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String imagePath,
    String label,
    Widget destination,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal[200], // Warna background lingkaran
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons
                      .broken_image, // Fallback icon jika gambar tidak ditemukan
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[300], // Warna background label
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
