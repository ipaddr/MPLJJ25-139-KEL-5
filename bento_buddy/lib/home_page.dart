import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
import 'package:intl/intl.dart'; // Import untuk format tanggal
import 'package:bento_buddy/services/auth_service.dart'; // Import AuthService
import 'package:bento_buddy/login_page.dart'; // Import LoginPage untuk navigasi logout
import 'package:bento_buddy/sekolah.dart'; // Import model Sekolah dan SekolahPage dari file terpisah
import 'package:bento_buddy/menu.dart'; // Import menu.dart

// CustomHeader yang disatukan ke dalam file home_page.dart
class _CustomHeaderInternal extends StatefulWidget
    implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final String? userName;
  final String? userRoleDisplay;
  final String? userInstitutionName;

  const _CustomHeaderInternal({
    required this.onMenuPressed,
    this.userName,
    this.userRoleDisplay,
    this.userInstitutionName,
  });

  @override
  State<_CustomHeaderInternal> createState() => _CustomHeaderInternalState();

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}

class _CustomHeaderInternalState extends State<_CustomHeaderInternal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2378),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logo.png', // Pastikan aset ini ada
                  width: 32,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 32,
                    ); // Fallback icon
                  },
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.userName ?? 'Pengguna',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.userInstitutionName ??
                          widget.userRoleDisplay ??
                          'BentoBuddy User',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Menavigasi langsung ke halaman Menu.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Menu()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ListItemWidget untuk menampilkan kartu sekolah
class _SchoolCardWidget extends StatelessWidget {
  final Sekolah sekolah; // Menggunakan model Sekolah dari sekolah.dart
  final VoidCallback onTap;

  const _SchoolCardWidget({required this.sekolah, required this.onTap});

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
              ClipRRect(borderRadius: BorderRadius.circular(8)),
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
                      'Total: ${sekolah.totalPorsi}',
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  String? _userName;
  String? _userRole;
  String? _userInstitutionName;
  String? _userRoleDisplay;

  List<Sekolah> _allSchoolsData = [];
  List<Sekolah> _filteredSchoolsData = [];
  Map<String, String> _cateringsMap = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Muat data pengguna dan sekolah saat inisialisasi
    _searchController.addListener(_filterSekolah); // Listener untuk search bar
  }

  // Fungsi untuk memuat data awal (pengguna, katering, dan mendengarkan sekolah)
  Future<void> _loadInitialData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = data['name'];
          _userRole = data['role'];
          switch (_userRole) {
            case 'school':
              _userRoleDisplay = 'Admin Sekolah';
              _userInstitutionName = data['institutionName'];
              break;
            case 'catering':
              _userRoleDisplay = 'Admin Catering';
              _userInstitutionName = data['institutionName'];
              break;
            case 'funder':
              _userRoleDisplay = 'Admin Pemerintah';
              break;
            case 'general':
              _userRoleDisplay = 'Umum';
              break;
            default:
              _userRoleDisplay = 'Pengguna';
          }
        });
      }
    } else {
      // Jika tidak ada pengguna yang login saat HomePage diinisialisasi,
      // arahkan ke halaman login. Ini penting jika HomePage diakses tanpa login.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      });
      return; // Hentikan eksekusi lebih lanjut jika tidak ada user
    }

    // Muat semua data katering terlebih dahulu
    QuerySnapshot cateringSnapshot =
        await _firestore.collection('caterings').get();
    for (var doc in cateringSnapshot.docs) {
      _cateringsMap[doc.id] =
          doc['cateringName'] ?? 'Nama Catering Tidak Ditemukan';
    }

    // Mendengarkan perubahan pada koleksi 'schools'
    _firestore
        .collection('schools')
        .where(
          'isApproved',
          isEqualTo: true,
        ) // Filter hanya sekolah yang disetujui
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
      appBar: _CustomHeaderInternal(
        userName: _userName,
        userRoleDisplay: _userRoleDisplay,
        userInstitutionName: _userInstitutionName,
        onMenuPressed: () {
          // Aksi untuk menu di dalam _CustomHeaderInternal
          // Ini sudah dipindahkan ke onPressed IconButton di dalam _CustomHeaderInternal
        },
      ),
      body: SingleChildScrollView(
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
                  _buildSearchBar(),
                  const SizedBox(height: 10),
                  if (_searchController.text.isNotEmpty)
                    Text(
                      "Hasil pencarian untuk: '${_searchController.text}'",
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    )
                  else
                    const Text(
                      "Berikut adalah sekolah-sekolah yang telah menerima bantuan:",
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  const SizedBox(height: 10),
                  _allSchoolsData.isEmpty && _filteredSchoolsData.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredSchoolsData.length,
                        itemBuilder: (context, index) {
                          final sekolah = _filteredSchoolsData[index];
                          return _SchoolCardWidget(
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
                hintText: "Cari sekolah atau catering...",
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
