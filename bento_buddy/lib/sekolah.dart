import 'package:flutter/material.dart';

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
      home: const SekolahPage(),
    );
  }
}

class SekolahPage extends StatelessWidget {
  const SekolahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Menghilangkan tombol kembali default
        toolbarHeight: 100,
        backgroundColor: const Color(0xFF271A5A),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/logo.png', // Placeholder untuk gambar logo
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
              // Handle ketika tombol menu ditekan
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tombol Menu ditekan!')),
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
                      // Handle ketika tombol kembali ditekan
                      // Biasanya menggunakan Navigator.pop(context) untuk kembali ke halaman sebelumnya
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tombol Kembali ditekan!'),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SD N 01 Padang',
                    style: TextStyle(
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
                'assets/school_building.png', // Placeholder untuk gambar gedung sekolah
                height: 200,
                width: 300,
                fit: BoxFit.contain,
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
                // PERBAIKAN: Hapus 'const' di sini karena metode tidak bisa dipanggil dalam konstanta compile-time.
                children: [
                  _buildDetailRow('Nama Instansi', 'SD N 01 Padang'),
                  _buildDetailRow('Alamat', 'Jl. Parit No. 8 Padang'),
                  _buildDetailRow('Kepala Sekolah', 'Farastika Allistio Putri'),
                  _buildDetailRow('Kontak', '085378707219'),
                  _buildDetailRow('Email', 'sdn01padang@gmail.com'),
                  _buildDetailRow('Total Dana', 'Rp. 200.000.000 / Bulan'),
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
                // PERBAIKAN: Menggunakan ikon chat_bubble yang tersedia di Material Icons
                _buildSocialIcon(Icons.chat_bubble, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon WhatsApp ditekan!')),
                  );
                }),
                _buildSocialIcon(Icons.camera_alt, () {
                  // Ikon mirip Instagram
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon Instagram ditekan!')),
                  );
                }),
                _buildSocialIcon(Icons.send, () {
                  // Ikon mirip Telegram
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
              'assets/catering_logo_1.png', // Placeholder untuk logo catering 1
              'Laper\'in Catering',
              'Jl. Cendrawasih No. 27 - 12 Air Tawar Barat',
              '1.758 porsi/hari',
              '08 November 2024',
            ),
            const SizedBox(height: 15),
            _buildCateringCard(
              context,
              'assets/catering_logo_2.png', // Placeholder untuk logo catering 2
              'OndeMande Catering',
              'Jl. Parkit No. 8 Padang',
              '1.768 porsi/hari',
              '09 November 2024',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Metode pembantu untuk membuat baris detail informasi
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

  // Metode pembantu untuk membuat ikon sosial yang dapat diklik
  static Widget _buildSocialIcon(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0E0E0), // Latar belakang abu-abu muda untuk ikon
          ),
          child: Icon(icon, color: const Color(0xFF271A5A), size: 24),
        ),
      ),
    );
  }

  // Metode pembantu untuk membuat kartu informasi catering
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
              color: Colors.grey[200], // Latar belakang untuk logo perusahaan
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              logoAsset,
              height: 60,
              width: 60,
              fit: BoxFit.contain,
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
