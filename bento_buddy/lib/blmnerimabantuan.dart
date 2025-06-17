import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bento_buddy/sekolah.dart';
import 'package:bento_buddy/menu.dart';

class Blmnerimabantuan extends StatefulWidget {
  const Blmnerimabantuan({super.key});

  @override
  State<Blmnerimabantuan> createState() => _BlmnerimabantuanState();
}

class _BlmnerimabantuanState extends State<Blmnerimabantuan> {
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
        .where('isApproved', isEqualTo: false)
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
            _allSchoolsData.where((s) {
              return s.nama.toLowerCase().contains(query) ||
                  s.alamat.toLowerCase().contains(query) ||
                  (s.cateringName?.toLowerCase().contains(query) ?? false);
            }).toList();
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
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: const Color(0xFF271A5A),
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.school, size: 50, color: Colors.white),
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
            const Text(
              "Data Sekolah Belum Menerima",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Bantuan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSearchBar(),
            const SizedBox(height: 10),
            if (_searchController.text.isNotEmpty)
              Text(
                "Hasil pencarian untuk: '${_searchController.text}'",
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              )
            else
              const Text(
                "Sekolah yang belum menerima bantuan:",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  _allSchoolsData.isEmpty && _filteredSchoolsData.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _filteredSchoolsData.length,
                        itemBuilder: (context, index) {
                          final sekolah = _filteredSchoolsData[index];
                          return SchoolManagedCard(
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
                hintText: "Cari data sekolah...",
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

class SchoolManagedCard extends StatelessWidget {
  final Sekolah sekolah;
  final VoidCallback onTap;

  const SchoolManagedCard({
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
                child: const Icon(
                  Icons.account_balance,
                  size: 60,
                  color: Colors.deepPurple,
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
                    if (sekolah.cateringName != null &&
                        sekolah.cateringName!.isNotEmpty)
                      Text(
                        'Catering: ${sekolah.cateringName}',
                        style: const TextStyle(fontSize: 12),
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
            const Icon(Icons.school, color: Colors.white, size: 24),
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
