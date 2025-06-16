import 'package:flutter/material.dart';
import 'c_notif_menu.dart'; // Import NotifMenuPage
// import 'menu_hari_ini.dart'; // Tidak diperlukan langsung di UploadMenuPage, karena navigasi ke NotifMenuPage

class UploadMenuPage extends StatelessWidget {
  const UploadMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar/Header kustom (seperti di desain Anda)
            // Saya asumsikan CustomHeader ini ada di file terpisah, misalnya 'widgets/custom_header.dart'
            // Jika tidak, Anda perlu memindahkan definisi CustomHeader ini ke file yang dapat diakses,
            // atau memasukkan kode CustomHeader langsung di sini.
            const CustomHeader(), // Asumsi CustomHeader ada dan sudah diimport atau didefinisikan

            const SizedBox(height: 16),
            const Text(
              'Upload Menu', // Mengubah judul menjadi "Upload Menu"
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Form Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upload Gambar
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Nama Menu
                    const Text(
                      'Nama Menu :',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi
                    const Text(
                      'Deskripsi :',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tombol Kirim
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Tambahkan logika pengiriman menu yang sebenarnya di sini.
                          // Contoh: validasi form, unggah gambar ke Firebase Storage, simpan data ke Firestore, dll.

                          // Setelah proses pengiriman (dummy) berhasil:
                          // Navigasi ke NotifMenuPage dan hapus semua rute sebelumnya
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const NotifMenuPage(),
                            ),
                            (Route<dynamic> route) =>
                                false, // Menghapus semua rute dari stack
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1E2378,
                          ), // Warna biru tua
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          'Kirim',
                          style: TextStyle(color: Colors.white),
                        ),
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

// CustomHeader (dipindahkan di sini jika belum ada di file terpisah yang diimpor)
// Idealnya, widget seperti CustomHeader ditempatkan di file terpisah
// (misalnya 'widgets/custom_header.dart') dan diimpor di sini.
// Namun, untuk memastikan kode ini berfungsi jika CustomHeader tidak diimpor,
// saya sertakan definisinya di bagian bawah.
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
          ), // Ganti dengan Image.asset('assets/logo.png') jika ada
          const SizedBox(width: 8),
          const Text(
            'Farastika Allistio\nLaper\'in Cathering',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              // TODO: Navigasi ke HomePage atau Beranda
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
