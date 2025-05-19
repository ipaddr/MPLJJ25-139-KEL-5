import 'package:flutter/material.dart';

class Sekolah {
  final String nama;
  final String alamat;
  final String logoPath;

  Sekolah({required this.nama, required this.alamat, required this.logoPath});
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
        nama: 'SDN 1 Surakarta Barat',
        alamat: 'Jl. Melati No.1',
        logoPath: 'logosdn.png',
      ),
      Sekolah(
        nama: 'SMPN 2 Surakarta Barat',
        alamat: 'Jl. Kenanga No.5',
        logoPath: 'logosmp.png',
      ),
      Sekolah(
        nama: 'SMAN 3 Surakarta Barat',
        alamat: 'Jl. Mawar No.10',
        logoPath: 'logosma.png',
      ),
      Sekolah(
        nama: 'SDN 4 Surakarta Timur',
        alamat: 'Jl. Anggrek No.3',
        logoPath: 'logosdn.png',
      ),
      Sekolah(
        nama: 'SMPN 5 Surakarta Timur',
        alamat: 'Jl. Flamboyan No.7',
        logoPath: 'logosmp.png',
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
            const CustomHeader(),
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
                    logoPath: '',
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
  final String logoPath;

  const ListItemWidget({
    super.key,
    required this.nama,
    required this.alamat,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          Image.asset('assets/logo.png', width: 24, height: 24),
          const SizedBox(width: 8),
          const Text(
            'Farastika Allistio\nLaper\'in Catering',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
