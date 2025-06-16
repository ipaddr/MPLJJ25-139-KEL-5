import 'package:flutter/material.dart';
import 'nerimabantuan.dart'; // Import model Sekolah dan CustomHeader jika diperlukan
import 'menu.dart'; // Import menu.dart untuk navigasi ke halaman menu
import 'sekolah.dart'; // Import SekolahPage untuk navigasi ke detail sekolah

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;

  const CustomHeader({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2378), // Warna biru tua
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(
            40,
          ), // Sesuai gambar, kedua sisi melengkung
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Untuk meratakan konten
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logo.png',
                width: 32,
                height: 32,
              ), // Pastikan aset ini ada
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Farastika Allistio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Laper\'in Catering',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ), // Ikon menu di kanan atas
            onPressed: onMenuPressed,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0); // Tinggi AppBar
}

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final TextEditingController _searchController = TextEditingController();
  List<Sekolah> semuaSekolahPenerimaBantuan =
      []; // Untuk bagian "Data Sekolah Penerima Bantuan"
  List<Sekolah> hasilPencarianSekolah = [];

  @override
  void initState() {
    super.initState();
    // Data dummy untuk sekolah penerima bantuan, sesuai gambar.
    // Ini harus sinkron dengan data di nerimabantuan.dart jika Anda ingin konsisten.
    // Saya akan membuat data contoh yang sesuai dengan gambar.
    semuaSekolahPenerimaBantuan = [
      Sekolah(
        nama: 'SDN 01 Padang',
        alamat: 'Jl. Parkit No. 8 Padang',
        catering: 'Laper\'in Catering',
        total: '1.700 Porsi/hari',
        tanggal: 'since 09 November 2024',
        logoPath: 'assets/logosdn.png', // Pastikan path ini benar
      ),
      Sekolah(
        nama: 'SMPN 2 Padang Barat',
        alamat: 'Jl. Kenanga No.5',
        catering: 'Anande Catering',
        total: '500 Porsi/hari',
        tanggal: 'since 20 Maret 2024',
        logoPath: 'assets/logosmp.png', // Pastikan path ini benar
      ),
      Sekolah(
        nama: 'SMAN 3 Padang Selatan',
        alamat: 'Jl. Mawar No.10',
        catering: 'DeLuna Catering',
        total: '760 Porsi/hari',
        tanggal: 'since 05 Desember 2024',
        logoPath: 'assets/logosma.png', // Pastikan path ini benar
      ),
    ];
    hasilPencarianSekolah = semuaSekolahPenerimaBantuan;
    _searchController.addListener(_filterSekolah);
  }

  void _filterSekolah() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      hasilPencarianSekolah =
          semuaSekolahPenerimaBantuan
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
      appBar: CustomHeader(
        onMenuPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Menu()),
          );
        },
      ),
      body: SingleChildScrollView(
        // Gunakan SingleChildScrollView untuk memungkinkan scrolling seluruh body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Sekolah Penerima Bantuan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildSearchBar(), // Search bar
                  const SizedBox(height: 10),
                  // Teks hasil penelusuran
                  if (_searchController.text.isNotEmpty)
                    Text(
                      "Hasil pencarian untuk: '${_searchController.text}'",
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    )
                  else
                    const Text(
                      "Hasil penelusuran untuk 'Sumatera Barat'", // Default sesuai gambar
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  const SizedBox(height: 10),
                  // Daftar sekolah penerima bantuan
                  ListView.builder(
                    shrinkWrap:
                        true, // Penting agar ListView di dalam SingleChildScrollView dapat di-scroll
                    physics:
                        const NeverScrollableScrollPhysics(), // Menonaktifkan scroll ListView internal
                    itemCount: hasilPencarianSekolah.length,
                    itemBuilder: (context, index) {
                      final sekolah = hasilPencarianSekolah[index];
                      return ListItemWidgetBeranda(
                        sekolah: sekolah,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      SekolahPage(sekolahData: sekolah),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ), // Jarak antara daftar sekolah dan container selamat datang
            // Bagian "Selamat Datang Farastika!!"
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E2378), // Warna biru tua
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Selamat Datang Farastika!!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'BentoBuddy adalah aplikasi mobile yang menjadi jembatan antara sekolah, katering, dan pemerintah, agar semua proses—mulai dari penyaluran sampai laporan makanan—bisa dipantau real-time, transparan, dan akuntabel.',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify, // Agar teks rata kiri-kanan
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E2378),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ), // Sudut lebih bulat
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        // Navigasi ke halaman DataSekolahPage atau beranda lagi jika sudah di beranda
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataSekolahPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Ya, saya Mengerti',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.grey),
            onPressed: () {
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

// Mengadaptasi ListItemWidget untuk Beranda, menambahkan detail catering
class ListItemWidgetBeranda extends StatelessWidget {
  final Sekolah sekolah;
  final VoidCallback onTap;

  const ListItemWidgetBeranda({
    super.key,
    required this.sekolah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  sekolah.logoPath, // Menggunakan logoPath dari objek sekolah
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/school_building.png', // Fallback
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sekolah.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(sekolah.alamat, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      'Catering: ${sekolah.catering}', // Detail Catering
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Total: ${sekolah.total}', // Detail Total Porsi
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      sekolah.tanggal, // Detail Tanggal
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
