import 'package:flutter/material.dart';
import 'menu.dart'; // Import menu.dart untuk navigasi ke menu utama

// Model untuk data Pengajuan Sekolah
class PengajuanSekolah {
  final String namaSekolah;
  final String alamatSekolah;
  final bool disetujui; // true jika APPROVED, false jika REJECTED
  final String imagePath; // Path ke aset gambar sekolah

  const PengajuanSekolah({
    required this.namaSekolah,
    required this.alamatSekolah,
    required this.disetujui,
    required this.imagePath,
  });
}

class PPengajuanPage extends StatefulWidget {
  const PPengajuanPage({super.key});

  @override
  State<PPengajuanPage> createState() => _PPengajuanPageState();
}

class _PPengajuanPageState extends State<PPengajuanPage> {
  // Data dummy untuk daftar pengajuan sekolah
  List<PengajuanSekolah> daftarPengajuan = [];

  @override
  void initState() {
    super.initState();
    daftarPengajuan = const [
      PengajuanSekolah(
        namaSekolah: 'SD N 01 Padang Panjang',
        alamatSekolah: 'Jl. Parkit No II Padang',
        disetujui: true,
        imagePath: 'assets/school_building_green.png', // Aset gambar sekolah
      ),
      PengajuanSekolah(
        namaSekolah: 'SD N 02 Padang',
        alamatSekolah: 'Jl. Cendrawasih No 15 Padang',
        disetujui: false,
        imagePath: 'assets/school_building_blue.png', // Aset gambar sekolah
      ),
      PengajuanSekolah(
        namaSekolah: 'SD N 10 Padang',
        alamatSekolah: 'Jl. Parkit No IV Padang',
        disetujui: true,
        imagePath: 'assets/school_building_green.png', // Aset gambar sekolah
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
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
                  const Text(
                    'Pengajuan sekolah', // Judul halaman
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap:
                  true, // Agar ListView tidak mengambil semua ruang yang tersedia
              physics:
                  const NeverScrollableScrollPhysics(), // Menonaktifkan scroll ListView internal
              itemCount: daftarPengajuan.length,
              itemBuilder: (context, index) {
                final pengajuan = daftarPengajuan[index];
                return _buildPengajuanCard(context, pengajuan);
              },
            ),
            const SizedBox(height: 20), // Spasi di bagian bawah
          ],
        ),
      ),
    );
  }

  // Widget untuk membangun setiap kartu pengajuan
  Widget _buildPengajuanCard(BuildContext context, PengajuanSekolah pengajuan) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar sekolah
            Image.asset(
              pengajuan.imagePath,
              height: 60,
              width: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons
                      .school, // Fallback icon jika gambar sekolah tidak ditemukan
                  size: 60,
                  color: Colors.grey,
                );
              },
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama sekolah
                  Text(
                    pengajuan.namaSekolah,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Alamat sekolah
                  Text(
                    pengajuan.alamatSekolah,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            // Status (APPROVED/REJECTED)
            if (pengajuan.disetujui)
              Image.asset(
                'assets/diterima.png', //                 height: 50,
                width: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.check_circle,
                    size: 50,
                    color: Colors.green,
                  );
                },
              )
            else
              Image.asset(
                'assets/ditolak.png', //                 height: 50,
                width: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.cancel, size: 50, color: Colors.red);
                },
              ),
          ],
        ),
      ),
    );
  }
}
