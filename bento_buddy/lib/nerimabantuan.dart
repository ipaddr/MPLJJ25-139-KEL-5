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

class DataSekolahPage extends StatefulWidget {
  const DataSekolahPage({super.key});

  @override
  State<DataSekolahPage> createState() => _DataSekolahPageState();
}

class _DataSekolahPageState extends State<DataSekolahPage> {
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
    // Filter untuk sekolah yang SUDAH menerima bantuan (isApproved: true)
    _firestore
        .collection('schools')
        .where(
          'isApproved',
          isEqualTo: true,
        ) // Ini adalah asumsi untuk "sekolah yang telah menerima bantuan"
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
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              // CustomHeader dari file ini
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
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Berikut adalah daftar sekolah yang telah menerima bantuan:", // Pesan default yang lebih sesuai
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _allSchoolsData.isEmpty && _filteredSchoolsData.isEmpty
                      ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Tampilkan loading
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredSchoolsData.length,
                        itemBuilder: (context, index) {
                          final sekolah = _filteredSchoolsData[index];
                          return ListItemWidget(
                            // Menggunakan ListItemWidget yang dimodifikasi
                            sekolah: sekolah, // Meneruskan objek Sekolah
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ), // Memberi margin agar sesuai dengan padding halaman
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

// Modifikasi ListItemWidget untuk menerima objek Sekolah
// Sekarang mengambil data dari model Sekolah yang terpusat di `sekolah.dart`
class ListItemWidget extends StatelessWidget {
  final Sekolah sekolah; // Mengambil objek Sekolah langsung
  final VoidCallback onTap;

  const ListItemWidget({
    super.key,
    required this.sekolah, // Diperlukan objek Sekolah
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
                  sekolah.logoPath ??
                      'assets/school_building.png', // Gunakan logoPath dari objek sekolah
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      // Fallback image asset
                      'assets/school_building.png',
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
                      sekolah.nama, // Ambil dari objek
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sekolah.alamat,
                      style: const TextStyle(fontSize: 12),
                    ), // Ambil dari objek
                    const SizedBox(height: 4),
                    if (sekolah.cateringName != null &&
                        sekolah.cateringName!.isNotEmpty)
                      Text(
                        'Catering: ${sekolah.cateringName}', // Ambil dari objek
                        style: const TextStyle(fontSize: 12),
                      ),
                    Text(
                      'Jumlah: ${sekolah.totalPorsi}', // Ambil dari objek
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      sekolah.tanggalKonfirmasi, // Ambil dari objek
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

// CustomHeader yang Anda sediakan di nerimabantuan.dart
// Ini adalah versi yang berbeda dengan di home_page.dart (tidak dinamis dari Firebase)
class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  // Implementasi PreferredSizeWidget
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
