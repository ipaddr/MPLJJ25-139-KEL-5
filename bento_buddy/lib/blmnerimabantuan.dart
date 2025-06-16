import 'package:flutter/material.dart';
import 'menu.dart'; // Pastikan file ini ada
import 'nerimabantuan.dart'; // Mengimpor kelas Sekolah dari sini. Kelas Sekolah ini TIDAK const.

class Blmnerimabantuan extends StatefulWidget {
  const Blmnerimabantuan({super.key});

  @override
  State<Blmnerimabantuan> createState() => _BlmnerimabantuanState();
}

class _BlmnerimabantuanState extends State<Blmnerimabantuan> {
  final TextEditingController _searchController = TextEditingController();
  List<Sekolah> semuaSekolahBlmTerima = [];
  List<Sekolah> hasilPencarian = [];

  @override
  void initState() {
    super.initState();
    // Data dummy untuk sekolah yang BELUM menerima bantuan, sesuai gambar.
    // List ini sekarang inisialisasi non-const karena kelas Sekolah TIDAK const.
    semuaSekolahBlmTerima = [
      // **Hapus 'const' di sini**
      Sekolah(
        nama: 'SD N 01 Padang',
        alamat: 'Jl. Parit No 8 Padang', // Asumsi alamat
        logoPath: 'assets/sekolah.png', // Pastikan aset ini ada
        // Penting: Anda harus menyediakan semua parameter 'required' dari konstruktor Sekolah
        catering: '', // Nilai kosong karena belum menerima bantuan
        total: '', // Nilai kosong karena belum menerima bantuan
        tanggal: '', // Nilai kosong karena belum menerima bantuan
      ),
      Sekolah(
        nama: 'SD N 02 Padang',
        alamat: 'Jl. Air Tawar Barat', // Asumsi alamat
        logoPath: 'assets/sekolah.png',
        catering: '',
        total: '',
        tanggal: '',
      ),
      Sekolah(
        nama: 'SD N 03 Padang',
        alamat: 'Jl. Steba', // Asumsi alamat
        logoPath: 'assets/sekolah.png',
        catering: '',
        total: '',
        tanggal: '',
      ),
      Sekolah(
        nama: 'SD N 01 Padang', // Duplikasi sesuai gambar
        alamat: 'Jl. Khatib Sulaiman', // Asumsi alamat
        logoPath: 'assets/sekolah.png',
        catering: '',
        total: '',
        tanggal: '',
      ),
      Sekolah(
        nama: 'SD N 02 Padang', // Duplikasi sesuai gambar
        alamat: 'Jl. Kapau Koto Panjang', // Asumsi alamat
        logoPath: 'assets/sekolah.png',
        catering: '',
        total: '',
        tanggal: '',
      ),
      Sekolah(
        nama: 'SD N 03 Padang', // Sesuai gambar, saya asumsikan SD N 03 Darlann
        alamat: 'Jl. Darlann', // Asumsi alamat
        logoPath: 'assets/sekolah.png',
        catering: '',
        total: '',
        tanggal: '',
      ),
      // Tambahkan data sekolah lain yang belum menerima bantuan di sini
    ];
    hasilPencarian = semuaSekolahBlmTerima;
    _searchController.addListener(_filterSekolah);
  }

  void _filterSekolah() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      hasilPencarian =
          semuaSekolahBlmTerima
              .where(
                (s) =>
                    s.nama.toLowerCase().contains(query) ||
                    s.alamat.toLowerCase().contains(query),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    color: Colors.red,
                    size: 50,
                  ); // Fallback icon
                },
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul halaman "Data Sekolah Belum Menerima Bantuan"
            const Text(
              "Data Sekolah Belum Menerima",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Bantuan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSearchBar(), // Menggunakan search bar yang mirip dengan halaman lain
            const SizedBox(height: 10),
            if (_searchController.text.isNotEmpty)
              Text(
                "Hasil pencarian untuk: '${_searchController.text}'",
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              )
            else
              const Text(
                "Hasil penelusuran untuk 'Sumatera Barat'",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: hasilPencarian.length,
                itemBuilder: (context, index) {
                  final sekolah = hasilPencarian[index];
                  return SchoolManagedCard(
                    sekolah: sekolah,
                  ); // Menggunakan kartu yang disesuaikan
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white, // Warna background putih sesuai gambar
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300), // Border tipis
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari data sekolah...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.grey),
            onPressed: () {
              // Aksi untuk filter
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter icon pressed!')),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Card untuk menampilkan sekolah yang dikelola (mirip dengan yang ada di laperin_catering.dart)
class SchoolManagedCard extends StatelessWidget {
  final Sekolah sekolah; // Menggunakan model Sekolah

  const SchoolManagedCard({super.key, required this.sekolah});

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
                sekolah.logoPath, // Menggunakan logoPath dari objek sekolah
                height: 60,
                width: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/school_building.png', // Fallback gedung sekolah (pastikan aset ini ada)
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
                    sekolah.nama,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    sekolah.alamat,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  // Opsional: Anda bisa menampilkan properti catering, total, tanggal jika ingin
                  // Meskipun untuk "belum menerima bantuan", nilai-nilainya mungkin kosong.
                  // Text('Catering: ${sekolah.catering}', style: const TextStyle(fontSize: 12)),
                  // Text('Total: ${sekolah.total}', style: const TextStyle(fontSize: 12)),
                  // Text(sekolah.tanggal, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
