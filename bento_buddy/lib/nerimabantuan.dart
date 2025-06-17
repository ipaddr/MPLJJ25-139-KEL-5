import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bento_buddy/sekolah.dart';
import 'package:bento_buddy/menu.dart';

class DataSekolahPage extends StatefulWidget {
  const DataSekolahPage({super.key});

  @override
  State<DataSekolahPage> createState() => _DataSekolahPageState();
}

class _DataSekolahPageState extends State<DataSekolahPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Sekolah> _allSchoolsData = [];
  List<Sekolah> _filteredSchoolsData = [];
  Map<String, String> _cateringsMap = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_filterSekolah);
  }

  Future<void> _loadInitialData() async {
    QuerySnapshot cateringSnapshot =
        await _firestore.collection('caterings').get();
    for (var doc in cateringSnapshot.docs) {
      _cateringsMap[doc.id] =
          doc['cateringName'] ?? 'Nama Catering Tidak Ditemukan';
    }

    _firestore
        .collection('schools')
        .where('isApproved', isEqualTo: true)
        .snapshots()
        .listen(
          (snapshot) {
            List<Sekolah> loadedSchools =
                snapshot.docs
                    .map((doc) => Sekolah.fromFirestore(doc, _cateringsMap))
                    .toList();
            setState(() {
              _allSchoolsData = loadedSchools;
              _filterSekolah();
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
                  "Berikut adalah daftar sekolah yang telah menerima bantuan:",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _allSchoolsData.isEmpty && _filteredSchoolsData.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredSchoolsData.length,
                        itemBuilder: (context, index) {
                          final sekolah = _filteredSchoolsData[index];
                          return ListItemWidget(
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

class ListItemWidget extends StatelessWidget {
  final Sekolah sekolah;
  final VoidCallback onTap;

  const ListItemWidget({super.key, required this.sekolah, required this.onTap});

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
              const Icon(Icons.school, size: 50, color: Colors.blueAccent),
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
                    if (sekolah.cateringName != null &&
                        sekolah.cateringName!.isNotEmpty)
                      Text(
                        'Catering: ${sekolah.cateringName}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    Text(
                      'Jumlah: ${sekolah.totalPorsi}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      sekolah.tanggalKonfirmasi,
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
        child: Row(
          children: [
            const Icon(Icons.restaurant_menu, size: 24, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              'Farastika Allistio\nLaper\'in Catering',
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
  Size get preferredSize => const Size.fromHeight(100.0);
}
