import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
import 'package:intl/intl.dart'; // Import untuk format tanggal
import 'package:bento_buddy/sekolah.dart'; // Import file sekolah.dart (yang berisi model Sekolah dan SekolahPage)
import 'package:bento_buddy/menu.dart'; // Import menu.dart (pastikan path ini benar)

// HAPUS SEPENUHNYA DEFINISI KELAS SEKOLAH DARI SINI.
// Definisi kelas Sekolah sudah dipindahkan ke `sekolah.dart`.
// class Sekolah {
//   final String nama;
//   final String alamat;
//   final String catering;
//   final String total;
//   final String tanggal;
//   final String logoPath;

//   Sekolah({
//     required this.nama,
//     required this.alamat,
//     required this.catering,
//     required this.total,
//     required this.tanggal,
//     required this.logoPath,
//   });
// }

class Blmnerimabantuan extends StatefulWidget {
  const Blmnerimabantuan({super.key});

  @override
  State<Blmnerimabantuan> createState() => _BlmnerimabantuanState();
}

class _BlmnerimabantuanState extends State<Blmnerimabantuan> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Sekolah> _allSchoolsData = []; // Data sekolah dari Firestore
  List<Sekolah> _filteredSchoolsData = []; // Hasil pencarian
  Map<String, String> _cateringsMap = {}; // Map: cateringId -> cateringName

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Muat data dari Firebase
    _searchController.addListener(_filterSekolah);
  }

  // Fungsi untuk memuat data sekolah dari Firestore
  Future<void> _loadInitialData() async {
    // Muat semua data katering terlebih dahulu untuk resolusi nama
    QuerySnapshot cateringSnapshot =
        await _firestore.collection('caterings').get();
    for (var doc in cateringSnapshot.docs) {
      _cateringsMap[doc.id] =
          doc['cateringName'] ?? 'Nama Catering Tidak Ditemukan';
    }

    // Mendengarkan perubahan pada koleksi 'schools'
    // Filter untuk sekolah yang BELUM menerima bantuan (isApproved: false)
    _firestore
        .collection('schools')
        .where(
          'isApproved',
          isEqualTo: false,
        ) // Filter khusus untuk sekolah yang belum disetujui/menerima bantuan
        .snapshots()
        .listen(
          (snapshot) {
            List<Sekolah> loadedSchools =
                snapshot.docs
                    .map((doc) => Sekolah.fromFirestore(doc, _cateringsMap))
                    .toList();
            setState(() {
              _allSchoolsData = loadedSchools;
              _filterSekolah(); // Terapkan filter setelah data dimuat/diperbarui
            });
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading schools: $error')),
            );
          },
        );
  }

  void _filterSekolah() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSchoolsData = _allSchoolsData;
      } else {
        _filteredSchoolsData =
            _allSchoolsData
                .where(
                  (s) =>
                      s.nama.toLowerCase().contains(query) ||
                      s.alamat.toLowerCase().contains(query) ||
                      (s.cateringName?.toLowerCase().contains(query) ?? false),
                )
                .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterSekolah);
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
                  'Farastika Allistio', // Ini masih hardcoded di sini
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Laper\'in Gathering', // Ini masih hardcoded di sini
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
                "Sekolah yang belum menerima bantuan:", // Default teks untuk halaman ini
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  _allSchoolsData.isEmpty && _filteredSchoolsData.isEmpty
                      ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Tampilkan loading
                      : ListView.builder(
                        itemCount: _filteredSchoolsData.length,
                        itemBuilder: (context, index) {
                          final sekolah = _filteredSchoolsData[index];
                          return SchoolManagedCard(
                            // Menggunakan SchoolManagedCard
                            sekolah: sekolah, // Meneruskan objek Sekolah
                            onTap: () {
                              // Tambahkan onTap agar kartu bisa diklik
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
      ), // Dihapus margin horizontal 16
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
// Menggunakan model Sekolah dari sekolah.dart
class SchoolManagedCard extends StatelessWidget {
  final Sekolah sekolah; // Menggunakan model Sekolah
  final VoidCallback onTap; // Tambahkan onTap

  const SchoolManagedCard({
    super.key,
    required this.sekolah,
    required this.onTap,
  }); // Perbarui konstruktor

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Bungkus dengan InkWell agar bisa diklik
      onTap: onTap,
      child: Card(
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
                  sekolah.logoPath ??
                      'assets/school_building.png', // Menggunakan logoPath dari objek sekolah
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
                    // Meskipun untuk "belum menerima bantuan", nilai-nilai ini mungkin kosong atau "Tidak Tersedia".
                    if (sekolah.cateringName != null &&
                        sekolah.cateringName!.isNotEmpty)
                      Text(
                        'Catering: ${sekolah.cateringName}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    // Contoh jika ingin menampilkan tanggal konfirmasi walaupun belum disetujui (misal: tanggal pengajuan)
                    // if (sekolah.tanggalKonfirmasi != null && sekolah.tanggalKonfirmasi!.isNotEmpty)
                    //   Text('Diajukan: ${sekolah.tanggalKonfirmasi}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
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

// CustomHeader yang Anda sediakan di nerimabantuan.dart (ini akan dipertahankan di sini)
// Jika Anda ingin CustomHeader ini menampilkan nama & peran dinamis, itu akan membutuhkan
// perubahan yang sama seperti di CustomHeader pada home_page.dart
class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;

  const CustomHeader({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2378),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
      ),
      child: SafeArea(
        // Tambahkan SafeArea untuk menghindari tumpang tindih dengan status bar
        child: Row(
          children: [
            Image.asset('assets/logo.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text(
              'Farastika Allistio\nLaper\'in Catering', // Teks ini masih hardcoded
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: onMenuPressed,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0); // Implementasi ukuran AppBar
}
