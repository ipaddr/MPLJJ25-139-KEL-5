import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bento_buddy/sekolah.dart'; // Import model Sekolah dan SekolahPage
import 'package:bento_buddy/menu.dart'; // Import menu.dart jika CustomHeader memerlukan navigasi ke menu
import 'package:bento_buddy/login_page.dart'; // Import login_page.dart untuk logout
import 'package:bento_buddy/services/auth_service.dart'; // Import AuthService untuk logout

class PengelolaPengajuanPage extends StatefulWidget {
  const PengelolaPengajuanPage({super.key});

  @override
  State<PengelolaPengajuanPage> createState() => _PengelolaPengajuanPageState();
}

class _PengelolaPengajuanPageState extends State<PengelolaPengajuanPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  Map<String, String> _cateringsMap = {}; // Untuk memetakan ID katering ke nama
  String? _userName;
  String? _userRoleDisplay;
  String? _userInstitutionName;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Muat data pengguna untuk header
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = data['name'];
          switch (data['role']) {
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
    }

    // Muat semua data katering terlebih dahulu
    QuerySnapshot cateringSnapshot =
        await _firestore.collection('caterings').get();
    for (var doc in cateringSnapshot.docs) {
      _cateringsMap[doc.id] =
          doc['cateringName'] ?? 'Nama Catering Tidak Ditemukan';
    }
  }

  // Fungsi untuk menerima pengajuan sekolah
  Future<void> _acceptApplication(String schoolId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await _firestore.collection('schools').doc(schoolId).update({
        'isApproved': true,
        'confirmedDate': Timestamp.now(), // Set tanggal konfirmasi
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan sekolah berhasil diterima!')),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menerima pengajuan: $e')),
      );
    }
  }

  // Fungsi untuk menolak pengajuan sekolah
  Future<void> _denyApplication(String schoolId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await _firestore.collection('schools').doc(schoolId).delete();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan sekolah berhasil ditolak!')),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menolak pengajuan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _CustomHeaderForPengelola(
        // Custom Header untuk halaman ini
        userName: _userName,
        userRoleDisplay: _userRoleDisplay,
        userInstitutionName: _userInstitutionName,
        onMenuPressed: () {
          // Aksi untuk menu di dalam _CustomHeaderForPengelola
        },
        onBackPressed: () {
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pengajuan Sekolah Baru (Menunggu Persetujuan)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('schools')
                  .where('isApproved',
                      isEqualTo: false) // Filter hanya yang belum disetujui
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada pengajuan sekolah baru.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    // Buat objek Sekolah dari DocumentSnapshot
                    final sekolah = Sekolah.fromFirestore(doc, _cateringsMap);

                    return _PengajuanSchoolCard(
                      sekolah: sekolah,
                      onAccept: () => _acceptApplication(doc.id),
                      onDeny: () => _denyApplication(doc.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Card untuk setiap pengajuan sekolah
class _PengajuanSchoolCard extends StatelessWidget {
  final Sekolah sekolah;
  final VoidCallback onAccept;
  final VoidCallback onDeny;

  const _PengajuanSchoolCard({
    required this.sekolah,
    required this.onAccept,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      (sekolah.logoPath != null && sekolah.logoPath!.isNotEmpty)
                          ? Image.asset(
                              sekolah.logoPath!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback ke Icon jika asset bermasalah
                                return const Icon(
                                  Icons.school_outlined, // Ikon sekolah generik
                                  size: 60,
                                  color: Colors.grey,
                                );
                              },
                            )
                          : const Icon(
                              // Fallback ke Icon jika logoPath null atau kosong
                              Icons.school_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sekolah.nama,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        sekolah.alamat,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        sekolah
                            .tanggalKonfirmasi, // Ini akan menampilkan tanggal pengajuan (createdAt)
                        style: const TextStyle(
                            fontSize: 12, color: Colors.blueGrey),
                      ),
                      // Tampilkan nama kontak, nomor telepon, dan email jika ada
                      if (sekolah.kepalaSekolah != null &&
                          sekolah.kepalaSekolah != 'Tidak Tersedia')
                        Text('Kontak: ${sekolah.kepalaSekolah}',
                            style: const TextStyle(fontSize: 12)),
                      if (sekolah.kontakSekolah != null &&
                          sekolah.kontakSekolah != 'Tidak Tersedia')
                        Text('No. Telp: ${sekolah.kontakSekolah}',
                            style: const TextStyle(fontSize: 12)),
                      if (sekolah.emailSekolah != null &&
                          sekolah.emailSekolah != 'Tidak Tersedia')
                        Text('Email: ${sekolah.emailSekolah}',
                            style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Terima',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onDeny,
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text('Tolak',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Header yang disesuaikan untuk halaman PengelolaPengajuanPage
class _CustomHeaderForPengelola extends StatefulWidget
    implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onBackPressed; // Tombol kembali
  final String? userName;
  final String? userRoleDisplay;
  final String? userInstitutionName;

  const _CustomHeaderForPengelola({
    required this.onMenuPressed,
    required this.onBackPressed,
    this.userName,
    this.userRoleDisplay,
    this.userInstitutionName,
  });

  @override
  State<_CustomHeaderForPengelola> createState() =>
      _CustomHeaderForPengelolaState();

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}

class _CustomHeaderForPengelolaState extends State<_CustomHeaderForPengelola> {
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
            IconButton(
              // Tombol kembali di sisi kiri
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: widget.onBackPressed,
            ),
            Expanded(
              // Memastikan teks di tengah tidak tumpang tindih
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback ke Icon jika asset bermasalah
                      return const Icon(Icons.school,
                          color: Colors.white, size: 32);
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
                            'Admin BentoBuddy',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
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
