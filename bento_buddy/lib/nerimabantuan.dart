import 'package:flutter/material.dart';
import 'sekolah.dart'; // Import file sekolah.dart
import 'menu.dart'; // Import menu.dart

class Sekolah {
  final String nama;
  final String alamat;
  final String catering;
  final String total;
  final String tanggal;
  final String logoPath;

  Sekolah({
    required this.nama,
    required this.alamat,
    required this.catering,
    required this.total,
    required this.tanggal,
    required this.logoPath,
  });
}

class DataSekolahPage extends StatefulWidget {
  const DataSekolahPage({super.key});

  @override
  State<DataSekolahPage> createState() => _DataSekolahPageState();
}

class _DataSekolahPageState extends State<DataSekolahPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Sekolah> semuaSekolah = [];
  List<Sekolah> hasilPencarian = [];

  @override
  void initState() {
    super.initState();
    semuaSekolah = [
      Sekolah(
        nama: 'SDN 01 Padang',
        alamat: 'Jl. Parkit No. 8 Padang',
        catering: 'Laper\'in Catering',
        total: '1.700 Porsi/hari',
        tanggal: 'since 09 November 2024',
        logoPath: 'assets/logosdn.png', // Pastikan path ini benar
      ),
      Sekolah(
        nama: 'SMPN 2 Surakarta Barat',
        alamat: 'Jl. Kenanga No.5',
        catering: 'Anande Catering',
        total: '500 Porsi/hari',
        tanggal: 'since 20 Maret 2024',
        logoPath: 'assets/logosmp.png', // Pastikan path ini benar
      ),
      Sekolah(
        nama: 'SMAN 3 Surakarta Barat',
        alamat: 'Jl. Mawar No.10',
        catering: 'DeLuna Catering',
        total: '760 Porsi/hari',
        tanggal: 'since 05 Desember 2024',
        logoPath: 'assets/logosma.png', // Pastikan path ini benar
      ),
      Sekolah(
        nama: 'SDN 4 Surakarta Timur',
        alamat: 'Jl. Anggrek No.3',
        catering: 'OndeMande Catering',
        total: '287 Porsi/hari',
        tanggal: 'since 12 Desember 2024',
        logoPath: 'assets/logosdn.png', // Pastikan path ini benar
      ),
      Sekolah(
        nama: 'SMPN 5 Surakarta Timur',
        alamat: 'Jl. Flamboyan No.7',
        catering: 'Golden City Catering',
        total: '456 Porsi/hari',
        tanggal: 'since 17 April 2024',
        logoPath: 'assets/logosmp.png', // Pastikan path ini benar
      ),
    ];
    hasilPencarian = semuaSekolah;
    _searchController.addListener(_filterSekolah);
  }

  void _filterSekolah() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      hasilPencarian =
          semuaSekolah
              .where((s) => s.nama.toLowerCase().contains(query))
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
      body: SafeArea(
        child: Column(
          children: [
            // Meneruskan Navigator ke CustomHeader agar bisa mengakses Navigator.push
            CustomHeader(
              onMenuPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Menu()),
                );
              },
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Data Sekolah Penerima Bantuan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 8),
            if (_searchController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Hasil pencarian untuk "${_searchController.text}"',
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: hasilPencarian.length,
                itemBuilder: (context, index) {
                  final sekolah = hasilPencarian[index];
                  return ListItemWidget(
                    nama: sekolah.nama,
                    alamat: sekolah.alamat,
                    catering: sekolah.catering,
                    total: sekolah.total,
                    tanggal: sekolah.tanggal,
                    logoPath:
                        sekolah
                            .logoPath, // Meneruskan logoPath dari model Sekolah
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SekolahPage(sekolahData: sekolah),
                        ),
                      );
                    },
                  );
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              // Tambahkan filter jika diperlukan
            },
          ),
        ],
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final String nama;
  final String alamat;
  final String catering;
  final String total;
  final String tanggal;
  final String logoPath;
  final VoidCallback onTap;

  const ListItemWidget({
    super.key,
    required this.nama,
    required this.alamat,
    required this.catering,
    required this.total,
    required this.tanggal,
    required this.logoPath,
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
                  logoPath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
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
                      nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(alamat, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      'Catering: $catering',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Jumlah: $total',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      tanggal,
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

class CustomHeader extends StatelessWidget {
  final VoidCallback onMenuPressed; // Tambahkan properti VoidCallback

  const CustomHeader({super.key, required this.onMenuPressed});

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
          Image.asset('assets/logo.png', width: 24, height: 24),
          const SizedBox(width: 8),
          const Text(
            'Farastika Allistio\nLaper\'in Catering',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: onMenuPressed, // Panggil callback saat ikon ditekan
          ),
        ],
      ),
    );
  }
}
