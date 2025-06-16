// laperin_catering.dart
import 'package:flutter/material.dart';
import 'menu.dart'; // Import menu.dart untuk navigasi ke halaman menu

// Model data untuk sekolah yang dikelola
class ManagedSchool {
  final String name;
  final String address;
  final String totalPorsi;
  final String sinceDate;
  final String logoAssetPath;

  const ManagedSchool({
    // Ditambahkan const di sini
    required this.name,
    required this.address,
    required this.totalPorsi,
    required this.sinceDate,
    required this.logoAssetPath,
  });
}

class LaperinCatering extends StatelessWidget {
  const LaperinCatering({super.key});

  // Data dummy untuk sekolah yang dikelola, sesuai dengan gambar
  final List<ManagedSchool> managedSchools = const [
    ManagedSchool(
      name: 'SD N 01 Padang',
      address: 'Jl. Cendrawasih No 21 C Air Tawar Barat',
      totalPorsi: '1.768 porsi/hari',
      sinceDate: 'Since : 09 November 2024',
      logoAssetPath:
          'assets/sekolah.png', // Asumsi ini logo sekolah umum atau spesifik SDN 01
    ),
    ManagedSchool(
      name: 'SD N 08 Padang Utara',
      address: 'Jl. Melati No 12 Padang Utara',
      totalPorsi: '985 porsi/hari',
      sinceDate: 'Since : 21 Desember 2024',
      logoAssetPath: 'assets/sekolah.png', // Asumsi ini logo sekolah umum
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hapus tombol back default
        toolbarHeight: 100, // Sesuaikan tinggi AppBar
        backgroundColor: const Color(0xFF271A5A), // Warna sesuai AppBar lain
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/logo.png', // Logo aplikasi utama
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Menu()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Tombol kembali
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Laper'in Catering",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/laper.png', // Asumsi Anda punya logo spesifik Laper'in Catering
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/laper.png', // Fallback, jika laperin_logo.png tidak ada
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF271A5A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  // Hapus 'const' di sini karena _buildDetailRow adalah metode dan bukan konstanta
                  children: <Widget>[
                    _buildDetailRow('Nama Instansi', 'Laper\'in Catering'),
                    _buildDetailRow(
                      'Alamat',
                      'Jl. Cendrawasih No 21 C Air Tawar Barat',
                    ),
                    _buildDetailRow('Owner', 'Farastika Allistio Putri'),
                    _buildDetailRow('Kontak', '085378707219'),
                    _buildDetailRow('Email', 'lapercatering@gmail.com'),
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
                    // Menggunakan Icons.message sebagai alternatif untuk WhatsApp
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
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  'Sekolah yang dikelola',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Menggunakan ListView.builder untuk menampilkan daftar sekolah
              ListView.builder(
                shrinkWrap:
                    true, // Penting agar ListView di dalam SingleChildScrollView dapat di-scroll
                physics:
                    const NeverScrollableScrollPhysics(), // Menonaktifkan scroll ListView internal
                itemCount: managedSchools.length,
                itemBuilder: (context, index) {
                  final school = managedSchools[index];
                  return SchoolManagedCard(school: school);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi pembangun baris detail
  Widget _buildDetailRow(String label, String value) {
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

  // Fungsi pembangun ikon sosial
  Widget _buildSocialIcon(IconData icon, VoidCallback onPressed) {
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
}

// Widget khusus untuk menampilkan kartu sekolah yang dikelola
class SchoolManagedCard extends StatelessWidget {
  final ManagedSchool school;

  const SchoolManagedCard({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                school.logoAssetPath, // Logo sekolah
                height: 60,
                width: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/sekolah.png', // Fallback gedung sekolah
                    height: 60,
                    width: 60,
                    fit: BoxFit.contain,
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
                    school.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    school.address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.red),
                      const SizedBox(width: 5),
                      Text(
                        'Total : ${school.totalPorsi}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
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
                        school.sinceDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
