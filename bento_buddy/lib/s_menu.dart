import 'package:flutter/material.dart';
// Import halaman-halaman tujuan
import 'nerimabantuan.dart';
import 'blmnerimabantuan.dart';
import 'jasa_catering.dart';
import 's_menu_hari_ini.dart'; // asumsi ada MenuHariIni
import 's_profil.dart'; // asumsi ada ProfilPage
import 'login_page.dart'; // Import LoginPage untuk navigasi logout

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Warna latar belakang keseluruhan
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1464), // Warna AppBar
        toolbarHeight: 80, // Tinggi AppBar
        title: Row(
          children: [
            // Ikon atau Logo di AppBar
            const Icon(
              Icons.school, // [Image of School Icon]
              size: 32,
              color: Colors.white,
            ), // Atau Image.asset('assets/logo.png', width: 32, height: 32) jika menggunakan aset gambar
            const SizedBox(width: 10),
            // Info pengguna
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Farastika Allistio", // [Image of User Name]
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "Laper'in Cathering", // [Image of Catering Name]
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
            const Spacer(), // Memberikan ruang kosong fleksibel
            // Ikon menu di AppBar (tetap sebagai ikon menu, bisa pop jika ingin menutup menu)
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ), // [Image of Menu Icon]
              onPressed: () {
                // Di halaman menu, menekan ikon menu bisa jadi untuk menutup menu
                // atau tidak melakukan apa-apa.
                // Jika menu ini adalah root dari navigasi, Anda mungkin ingin pop.
                // Jika ini adalah halaman yang bisa diakses dari berbagai tempat,
                // maka Navigator.pop() akan membawa kembali ke halaman sebelumnya.
                Navigator.pop(
                  context,
                ); // Kembali ke halaman sebelumnya / menutup menu
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20), // Spasi vertikal
            const Text(
              'Mau cari apa?', // [Image of Question Text]
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24), // Spasi vertikal
            // Grid menu item
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 24, // Spasi horizontal antar item
                mainAxisSpacing: 24, // Spasi vertikal antar item
                children: [
                  _buildMenuItem(
                    context,
                    'assets/menerima.png', // [Image of Menerima Bantuan Icon]
                    'Menerima Bantuan',
                    const DataSekolahPage(), // Navigasi ke DataSekolahPage
                  ),
                  _buildMenuItem(
                    context,
                    'assets/belum_menerima.png', // [Image of Belum Menerima Bantuan Icon]
                    'Belum Menerima Bantuan',
                    const Blmnerimabantuan(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/cathering.png', // [Image of Cathering Icon]
                    'Cathering',
                    const JasaCateringPage(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/laporan.png', // [Image of Laporan Icon]
                    'Menu', // Label diubah menjadi "Menu" sesuai gambar sebelumnya
                    // Pastikan MenuHariIni ada di menu_hari_ini.dart
                    const SMenuHariIni(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/profil.png', // [Image of Profil Icon]
                    'Profil',
                    // Pastikan ProfilPage ada di profil.dart
                    const SProfilPage(),
                  ),
                ],
              ),
            ),

            // Tombol Logout (Tombol Kembali telah dihapus)
            const SizedBox(height: 16), // Spasi sebelum tombol logout
            ElevatedButton(
              onPressed: () {
                // Logika Logout: Menavigasi ke LoginPage dan menghapus semua rute sebelumnya
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) =>
                      false, // Menghapus semua rute dari stack
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF1B1464,
                ), // [Image of Logout Button Color]
                foregroundColor: Colors.white, // Warna teks putih
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Sudut membulat
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ), // Padding tombol
                minimumSize: const Size(
                  double.infinity,
                  50,
                ), // Lebar penuh dan tinggi tetap
              ),
              child: const Text(
                'Logout', // [Image of Logout Text]
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16), // Spasi di bagian bawah
          ],
        ),
      ),
    );
  }

  // Helper method untuk membangun setiap item menu
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
              color: Colors.teal[200], // Warna background lingkaran ikon
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
