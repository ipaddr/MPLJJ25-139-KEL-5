import 'package:flutter/material.dart';
import 'blmnerimabantuan.dart'; // Pastikan path ini benar
import 'menu.dart'; // Import menu.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Details',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // Mengatur DataSekolahPage sebagai halaman awal untuk menampilkan daftar sekolah
      // Kemudian dari sana bisa navigasi ke SekolahPage
      home: const PDataSekolahPage(),
    );
  }
}

// Model untuk data sekolah
class Sekolah {
  final String nama;
  final String alamat;
  final String logoPath; // Path ke aset gambar logo sekolah
  // Tambahan properti jika diperlukan, namun untuk tampilan ini, ini cukup
  // final String catering; // Properti ini tidak digunakan di tampilan target
  // final String total;    // Properti ini tidak digunakan di tampilan target
  // final String tanggal;  // Properti ini tidak digunakan di tampilan target

  const Sekolah({
    required this.nama,
    required this.alamat,
    required this.logoPath,
    // this.catering = '', // Berikan nilai default atau hapus jika tidak lagi diperlukan
    // this.total = '',
    // this.tanggal = '',
  });
}

// Halaman untuk menampilkan daftar sekolah (jika diperlukan) atau sebagai wadah data
class PDataSekolahPage extends StatefulWidget {
  const PDataSekolahPage({super.key});

  @override
  State<PDataSekolahPage> createState() => _DataSekolahPageState();
}

class _DataSekolahPageState extends State<PDataSekolahPage> {
  // Contoh data dummy sekolah yang akan ditampilkan
  final List<Sekolah> daftarSekolah = const [
    Sekolah(
      nama: 'SD N 01 Padang',
      alamat: 'Jl. Parkit No II Padang Panjang',
      logoPath:
          'assets/sdn_01_padang.png', // Ganti dengan path logo yang sesuai
    ),
    // Tambahkan lebih banyak data sekolah jika diperlukan
  ];

  @override
  Widget build(BuildContext context) {
    // Untuk tujuan tampilan gambar, kita langsung menampilkan detail sekolah pertama
    // Jika Anda ingin daftar, Anda bisa menggunakan ListView.builder di sini
    return SekolahPage(sekolahData: daftarSekolah[0]);
  }
}

// Halaman detail sekolah yang akan disesuaikan tampilannya
class SekolahPage extends StatelessWidget {
  final Sekolah sekolahData;

  const SekolahPage({super.key, required this.sekolahData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        // Menggunakan PreferredSize untuk AppBar kustom
        preferredSize: const Size.fromHeight(
          100.0,
        ), // Tinggi AppBar yang disesuaikan
        child: AppBar(
          backgroundColor: const Color(0xFF271A5A),
          elevation: 0, // Menghilangkan bayangan AppBar
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Logo aplikasi
                          Image.asset(
                            'assets/logo.png', // Logo utama aplikasi
                            height: 50,
                            width: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons
                                    .fastfood, // Fallback icon jika logo tidak ada
                                color: Colors.white,
                                size: 50,
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          // Informasi pengguna
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Farastika Allistio',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Laper\'in Cathering',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Ikon Menu
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Menu(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Tidak ada baris kedua di sini, karena tombol kembali dan judul ada di body
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black, // Warna ikon kembali
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    sekolahData.nama, // Nama sekolah dari data dinamis
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Warna teks judul
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Image.asset(
                sekolahData
                    .logoPath, // Menggunakan logoPath dari objek sekolahData
                height: 200,
                width: 300,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/school_building_placeholder.png', // Gambar default jika logo sekolah tidak ada
                    height: 200,
                    width: 300,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF271A5A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  _buildDetailRow('Nama Instansi', sekolahData.nama),
                  _buildDetailRow('Alamat', sekolahData.alamat),
                  _buildDetailRow(
                    'Kepala Sekolah',
                    'Farastika Allistio Putri', // Hardcoded
                  ),
                  _buildDetailRow('Kontak', '085378707219'), // Hardcoded
                  _buildDetailRow(
                    'Email',
                    'sdn01padang@gmail.com', // Hardcoded
                  ),
                  // Hapus: _buildDetailRow('Total Dana', 'Rp. 200.000.000 / Bulan'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Icons.email, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon Email ditekan!')),
                  );
                }),
                _buildSocialIcon(Icons.message, () {
                  // Menggunakan Icons.message sebagai alternatif WhatsApp
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon WhatsApp ditekan!')),
                  );
                }),
                _buildSocialIcon(Icons.camera_alt, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon Instagram ditekan!')),
                  );
                }),
                _buildSocialIcon(Icons.send, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon Telegram ditekan!')),
                  );
                }),
              ],
            ),
            const SizedBox(height: 30),
            // Hapus: Bagian "Catering" dan _buildCateringCard
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text(
            //     'Catering',
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 15),
            // _buildCateringCard(
            //   context,
            //   'assets/laper.png', // Logo Laper'in Catering
            //   sekolahData.catering,
            //   sekolahData.alamat,
            //   sekolahData.total,
            //   sekolahData.tanggal,
            // ),
            // const SizedBox(height: 15),
            // _buildCateringCard(
            //   context,
            //   'assets/ondemande.png', // Logo OndeMande Catering
            //   'OndeMande Catering',
            //   'Jl. Parkit No. 8 Padang', // Hardcoded
            //   '1.768 porsi/hari',
            //   '09 November 2024',
            // ),
            // const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Blmnerimabantuan(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF271A5A), // Warna tombol
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Terima',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const Text(':', style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSocialIcon(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0E0E0),
          ),
          child: Icon(icon, color: const Color(0xFF271A5A), size: 24),
        ),
      ),
    );
  }

  // Metode _buildCateringCard tidak lagi digunakan, tetapi saya biarkan di sini jika Anda ingin melihat perbandingannya.
  /*
  static Widget _buildCateringCard(
    BuildContext context,
    String logoAsset,
    String name,
    String address,
    String total,
    String since,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              logoAsset,
              height: 60,
              width: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.grey,
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  address,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.people, size: 16, color: Colors.red),
                    const SizedBox(width: 5),
                    Text(
                      'Total : $total',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Since : $since',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  */
}
