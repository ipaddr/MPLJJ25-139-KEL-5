import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
import 'package:intl/intl.dart'; // Untuk format angka dan tanggal
import 'package:bento_buddy/services/auth_service.dart'; // Import AuthService untuk logout
import 'package:bento_buddy/login_page.dart'; // Import LoginPage untuk navigasi setelah logout
import 'package:bento_buddy/sekolah.dart'; // Import model Sekolah dan SekolahPage
import 'package:bento_buddy/menu.dart'; // Import menu.dart untuk navigasi dari bottom sheet

// Custom Header yang disatukan langsung ke dalam file profil.dart
class _CustomHeaderProfile extends StatefulWidget
    implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final String? userName;
  final String? userRoleDisplay;
  final String? userInstitutionName;

  const _CustomHeaderProfile({
    required this.onMenuPressed,
    this.userName,
    this.userRoleDisplay,
    this.userInstitutionName,
  });

  @override
  State<_CustomHeaderProfile> createState() => _CustomHeaderProfileState();

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}

class _CustomHeaderProfileState extends State<_CustomHeaderProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1752), // Warna AppBar ProfilPage
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
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              // Memastikan teks di tengah tidak tumpang tindih
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo.png', // Logo aplikasi utama
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person,
                          color: Colors.white, size: 32); // Fallback icon
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

// Widget untuk menampilkan satu baris informasi (Label: Value)
class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // Padding vertikal
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Penataan ke atas
        children: [
          SizedBox(
            width: 120, // Lebar tetap untuk label agar rapi
            child: Text(
              '$label : ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4), // Spasi horizontal
          Expanded(
            // Penting: Menggunakan Expanded untuk mencegah teks overflow
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow
                  .ellipsis, // Menambahkan "..." jika teks terlalu panjang
              maxLines: 2, // Membatasi teks maksimal 2 baris
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk menampilkan kartu informasi sekolah yang dikelola
class _ManagedSchoolCard extends StatelessWidget {
  final Sekolah sekolah; // Menggunakan model Sekolah

  const _ManagedSchoolCard({required this.sekolah, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: const Color(0xFFF2EEEE),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (sekolah.logoPath != null && sekolah.logoPath!.isNotEmpty)
                  ? Image.asset(
                      sekolah.logoPath!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.school_outlined,
                          size: 60,
                          color: Colors.grey,
                        );
                      },
                    )
                  : const Icon(
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
                  Row(
                    children: [
                      // Ikon gedung sekolah (gunakan aset atau fallback ikon)
                      Image.asset(
                        'assets/gedung.png', // Pastikan aset ini ada atau ubah ke ikon
                        width: 16,
                        height: 16,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.apartment,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          sekolah.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/lokasi.png', // Pastikan aset ini ada atau ubah ke ikon
                        width: 14,
                        height: 14,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          sekolah.alamat,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (sekolah.totalPorsi != null &&
                      sekolah.totalPorsi !=
                          '0 Porsi/hari') // Tampilkan hanya jika ada porsi
                    Row(
                      children: [
                        const Icon(Icons.people, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Total: ${sekolah.totalPorsi}',
                            style: const TextStyle(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.date_range,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          sekolah
                              .tanggalKonfirmasi, // Menggunakan tanggal konfirmasi
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _userName;
  String? _userEmail;
  String? _userRole;
  String? _userInstitutionName;
  String? _userNik;
  String? _userPhoneNumber; // Asumsi ada di koleksi users
  String? _userRoleDisplay; // Untuk tampilan peran yang user-friendly

  List<Sekolah> _managedSchools = []; // Daftar sekolah yang dikelola

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = data['name'];
          _userEmail = data['email'];
          _userRole = data['role'];
          _userNik = data['nik'];
          _userPhoneNumber = data['phoneNumber']; // Ambil nomor telepon
          _userInstitutionName = data['institutionName']; // Ambil nama instansi

          _userRoleDisplay = _mapRoleToDisplay(data['role']);

          _loadManagedSchools(
              currentUser.uid, _userRole, data['schoolId'], data['cateringId']);
        });
      }
    } else {
      // Jika tidak ada user login, mungkin redirect ke halaman login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  String _mapRoleToDisplay(String role) {
    switch (role) {
      case 'school':
        return 'Admin Sekolah';
      case 'catering':
        return 'Admin Catering';
      case 'funder':
        return 'Admin Pemerintah';
      case 'general':
        return 'Umum';
      default:
        return 'Pengguna';
    }
  }

  Future<void> _loadManagedSchools(
      String uid, String? role, String? schoolId, String? cateringId) async {
    List<Sekolah> tempSchools = [];
    Map<String, String> cateringsMap = {};

    // Pertama, muat semua nama katering untuk resolusi ID
    QuerySnapshot cateringSnapshot =
        await _firestore.collection('caterings').get();
    for (var doc in cateringSnapshot.docs) {
      cateringsMap[doc.id] =
          doc['cateringName'] ?? 'Nama Catering Tidak Ditemukan';
    }

    QuerySnapshot? schoolsSnapshot;

    if (role == 'catering' && cateringId != null) {
      // Untuk Admin Catering: tampilkan sekolah yang ditugaskan ke catering ini
      // Asumsi cateringId di dokumen users cocok dengan ID dokumen di koleksi caterings
      // Dan ada field 'assignedCateringId' di dokumen schools
      schoolsSnapshot = await _firestore
          .collection('schools')
          .where('assignedCateringId',
              isEqualTo: uid) // UID user catering adalah cateringId
          .where('isApproved', isEqualTo: true) // Hanya sekolah yang disetujui
          .get();
    } else if (role == 'school' && schoolId != null) {
      // Untuk Admin Sekolah: tampilkan hanya sekolah mereka sendiri
      schoolsSnapshot = await _firestore
          .collection('schools')
          .where(FieldPath.documentId,
              isEqualTo:
                  schoolId) // Filter berdasarkan Document ID sekolah mereka
          .get();
    } else if (role == 'funder') {
      // Untuk Admin Pemerintah: tampilkan semua sekolah yang disetujui
      schoolsSnapshot = await _firestore
          .collection('schools')
          .where('isApproved', isEqualTo: true)
          .get();
    }

    if (schoolsSnapshot != null) {
      for (var doc in schoolsSnapshot.docs) {
        tempSchools.add(Sekolah.fromFirestore(doc, cateringsMap));
      }
    }

    setState(() {
      _managedSchools = tempSchools;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _CustomHeaderProfile(
        userName: _userName,
        userRoleDisplay: _userRoleDisplay,
        userInstitutionName: _userInstitutionName,
        onMenuPressed: () {
          // Aksi untuk menu di dalam _CustomHeaderProfile
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Icon profil pengguna
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black12,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            // Informasi Instansi / Pribadi dalam sebuah Container berwarna
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1752),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoItem(
                      label: 'Nama Lengkap',
                      value: _userName ?? 'Tidak Tersedia'),
                  if (_userRole == 'school' ||
                      _userRole == 'catering' ||
                      _userRole == 'funder')
                    InfoItem(
                        label: 'Nama Instansi',
                        value: _userInstitutionName ?? 'Tidak Tersedia'),

                  InfoItem(
                      label: 'Email', value: _userEmail ?? 'Tidak Tersedia'),
                  InfoItem(
                      label: 'Nomor Identitas (NIK)',
                      value: _userNik ?? 'Tidak Tersedia'),
                  InfoItem(
                      label: 'Nomor Telepon',
                      value: _userPhoneNumber ?? 'Tidak Tersedia'),

                  // Peran hanya ditampilkan jika bukan "Umum" atau jika Anda ingin selalu ditampilkan
                  if (_userRole != 'general' &&
                      _userRoleDisplay != null &&
                      _userRoleDisplay!.isNotEmpty)
                    InfoItem(label: 'Peran', value: _userRoleDisplay!),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Judul "Sekolah yang dikelola"
            if (_userRole == 'catering' ||
                _userRole == 'school' ||
                _userRole == 'funder')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _userRole == 'school'
                        ? 'Sekolah Saya'
                        : 'Sekolah yang Dikelola',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            // Daftar sekolah yang dikelola
            if (_userRole == 'catering' ||
                _userRole == 'school' ||
                _userRole == 'funder')
              _managedSchools.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Tidak ada sekolah yang dikelola.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _managedSchools.length,
                      itemBuilder: (context, index) {
                        final sekolah = _managedSchools[index];
                        return _ManagedSchoolCard(sekolah: sekolah);
                      },
                    )
            else if (_userRole ==
                'general') // Untuk pengguna umum, tampilkan pesan berbeda atau kosongkan
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Anda tidak mengelola sekolah apa pun.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
