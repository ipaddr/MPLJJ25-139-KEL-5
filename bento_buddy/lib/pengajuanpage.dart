import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
import 'package:bento_buddy/services/auth_service.dart'; // Import AuthService
import 'package:bento_buddy/login_page.dart'; // Import LoginPage (untuk logout di header)
import 'notif_ajukan.dart'; // Import halaman notifikasi pengajuan
import 'package:bento_buddy/menu.dart'; // Import menu.dart jika header memiliki navigasi ke menu
// import 'package:bento_buddy/home_page.dart'; // Hapus ini jika _CustomHeaderInternal tidak diimpor

// CustomHeader yang disatukan langsung ke dalam file pengajuanpage.dart
class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback
      onMenuPressed; // Tetap diperlukan jika ada tombol menu di header
  final String? userName;
  final String? userRoleDisplay;
  final String? userInstitutionName;

  const CustomHeader({
    super.key,
    required this.onMenuPressed, // onMenuPressed harus ada
    this.userName,
    this.userRoleDisplay,
    this.userInstitutionName,
  });

  @override
  State<CustomHeader> createState() => _CustomHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}

class _CustomHeaderState extends State<CustomHeader> {
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
                  'assets/logo.png',
                  width: 32,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 32,
                    );
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
            // Mengganti tombol menu dengan fungsionalitas yang sama seperti di HomePage
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

// CustomTextField (tetap di sini atau dipindahkan ke file utilitas umum jika digunakan di banyak tempat)
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.grey.shade300,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class PengajuanSekolahPage extends StatefulWidget {
  const PengajuanSekolahPage({super.key});

  @override
  State<PengajuanSekolahPage> createState() => _PengajuanSekolahPageState();
}

class _PengajuanSekolahPageState extends State<PengajuanSekolahPage> {
  final TextEditingController _namaSekolahController = TextEditingController();
  final TextEditingController _alamatSekolahController =
      TextEditingController();
  final TextEditingController _namaKontakController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _userName;
  String? _userRoleDisplay;
  String? _userInstitutionName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
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
  }

  Future<void> _submitPengajuan() async {
    if (_namaSekolahController.text.isEmpty ||
        _alamatSekolahController.text.isEmpty ||
        _namaKontakController.text.isEmpty ||
        _noTeleponController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field harus diisi!')));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final String? currentUserId = _auth.currentUser?.uid;

      await _firestore.collection('schools').add({
        'schoolName': _namaSekolahController.text.trim(),
        'location': _alamatSekolahController.text.trim(),
        'contactPerson': _namaKontakController.text.trim(),
        'phoneNumber': _noTeleponController.text.trim(),
        'email': _emailController.text.trim(),
        'isApproved': false, // Status awal selalu false (menunggu persetujuan)
        'totalAidReceived': 0, // Awalnya 0
        'assignedCateringId': null, // Awalnya null
        'requestedBy': currentUserId, // UID pengguna yang mengajukan
        'createdAt': Timestamp.now(), // Waktu pengajuan
        'confirmedDate': null, // Tanggal konfirmasi awal null
      });

      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NotifAjukanPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengajukan: $e')));
    }
  }

  @override
  void dispose() {
    _namaSekolahController.dispose();
    _alamatSekolahController.dispose();
    _namaKontakController.dispose();
    _noTeleponController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Menggunakan CustomHeader yang ada di file ini
            CustomHeader(
              // Gunakan CustomHeader lokal
              userName: _userName,
              userRoleDisplay: _userRoleDisplay,
              userInstitutionName: _userInstitutionName,
              onMenuPressed: () {
                // Aksi untuk menu di dalam CustomHeader
              },
            ),

            // Tombol back & Judul
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(
                      context,
                    ), // Kembali ke halaman sebelumnya
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pengajuan\nSekolah Belum Terdaftar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Form Input
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Nama Sekolah',
                      controller: _namaSekolahController,
                    ),
                    CustomTextField(
                      label: 'Alamat Sekolah',
                      controller: _alamatSekolahController,
                    ),
                    CustomTextField(
                      label: 'Nama Kontak',
                      controller: _namaKontakController,
                    ),
                    CustomTextField(
                      label: 'No Telepon',
                      controller: _noTeleponController,
                      keyboardType: TextInputType.phone,
                    ),
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),

                    // Tombol Kirim
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _submitPengajuan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 21, 6, 87),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Kirim'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
