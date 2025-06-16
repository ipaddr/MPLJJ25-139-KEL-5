import 'package:flutter/material.dart';
import 'nerimabantuan.dart'; // Pastikan path ini benar
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
      // Set home ke DataSekolahPage sebagai halaman awal
      // Anda bisa mengubah ini ke Menu() jika Menu adalah halaman pertama
      home: const DataSekolahPage(),
    );
  }
}

class SekolahPage extends StatelessWidget {
  final Sekolah sekolahData;

  const SekolahPage({super.key, required this.sekolahData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Menghilangkan tombol kembali default dari AppBar
        toolbarHeight: 100,
        backgroundColor: const Color(0xFF271A5A),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/logo.png', // Logo utama aplikasi
                height: 50,
                width: 50,
              ),
            ),
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
                  'Laper\'in Gathering',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () {
              // Navigasi ke halaman Menu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Menu()),
              );
            },
          ),
        ],
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
                      Navigator.pop(
                        context,
                      ); // Kembali ke halaman sebelumnya (DataSekolahPage)
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    sekolahData.nama, // Nama sekolah dari data dinamis
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                    'assets/school_building.png', // Gambar default jika logo sekolah tidak ada
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
                    'Farastika Allistio Putri',
                  ), // Hardcoded
                  _buildDetailRow('Kontak', '085378707219'), // Hardcoded
                  _buildDetailRow(
                    'Email',
                    'sdn01padang@gmail.com',
                  ), // Hardcoded
                  _buildDetailRow(
                    'Total Dana',
                    'Rp. 200.000.000 / Bulan',
                  ), // Hardcoded
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Catering',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildCateringCard(
              context,
              'assets/laper.png', // Logo Laper'in Catering
              sekolahData.catering,
              sekolahData.alamat,
              sekolahData.total,
              sekolahData.tanggal,
            ),
            const SizedBox(height: 15),
            _buildCateringCard(
              context,
              'assets/ondemande.png', // Logo OndeMande Catering
              'OndeMande Catering',
              'Jl. Parkit No. 8 Padang', // Hardcoded
              '1.768 porsi/hari',
              '09 November 2024',
            ),
            const SizedBox(height: 20),
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
}
