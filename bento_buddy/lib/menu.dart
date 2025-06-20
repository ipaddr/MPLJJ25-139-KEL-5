import 'package:bento_buddy/blmnerimabantuan.dart';
import 'package:bento_buddy/menu_hari_ini.dart';
import 'package:bento_buddy/nerimabantuan.dart';
import 'package:bento_buddy/pengajuanpage.dart';
import 'package:bento_buddy/profil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bento_buddy/pengelola_pengajuan_page.dart'; // Import halaman pengelola pengajuan
import 'package:bento_buddy/login_page.dart'; // Import LoginPage
import 'package:bento_buddy/services/auth_service.dart'; // Import AuthService
import 'package:bento_buddy/chatbotpage.dart'; // Import ChatbotPage

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String? _userName;
  String? _userRole; // Untuk menyimpan peran pengguna
  String? _userRoleDisplay;
  String? _userInstitutionName;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Memuat data pengguna untuk header dan peran
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = data['name'];
          _userRole = data['role'];
          _userInstitutionName = data['institutionName'];
          switch (_userRole) {
            case 'school':
              _userRoleDisplay = 'Admin Sekolah';
              break;
            case 'catering':
              _userRoleDisplay = 'Admin Catering';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Warna latar belakang keseluruhan
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1464), // Warna AppBar
        toolbarHeight: 80, // Tinggi AppBar
        title: Row(
          children: [
            // Ikon atau Logo di AppBar
            Image.asset(
              'assets/logo.png', // [Image of Logo Aplikasi]
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.school,
                color: Colors.white,
                size: 50,
              ), // Fallback
            ),
            const SizedBox(width: 10),
            // Info pengguna
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName ?? "Pengguna", // Nama pengguna dinamis
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  _userInstitutionName ??
                      _userRoleDisplay ??
                      "BentoBuddy User", // Instansi atau peran dinamis
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
            const Spacer(), // Memberikan ruang kosong fleksibel
            // Ikon Chatbot
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatbotPage()),
                );
              },
            ),
            // Ikon menu di AppBar (tetap sebagai ikon menu, bisa pop jika ingin menutup menu)
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                    context); // Kembali ke halaman sebelumnya / menutup menu
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20), // Spasi vertikal
            const Text(
              'Mau cari apa?', // [Image of Question Text]
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24), // Spasi vertikal
            // Grid menu item (semua ditampilkan)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 24, // Spasi horizontal antar item
                mainAxisSpacing: 24, // Spasi vertikal antar item
                children: [
                  _buildMenuItem(
                      context,
                      'assets/menerima.png', // [Image of Menerima Bantuan Icon]
                      'Menerima Bantuan',
                      const DataSekolahPage(),
                      [
                        'school',
                        'catering',
                        'funder',
                        'general'
                      ], // Peran yang diizinkan
                      "Hanya Admin Pemerintah dan Admin Sekolah yang dapat mengakses ini."),
                  _buildMenuItem(
                      context,
                      'assets/belum_menerima.png', // [Image of Belum Menerima Bantuan Icon]
                      'Belum Menerima Bantuan',
                      const Blmnerimabantuan(),
                      [
                        'school',
                        'catering',
                        'funder',
                        'general'
                      ], // Peran yang diizinkan
                      "Hanya Admin Pemerintah dan Admin Sekolah yang dapat mengakses ini."),
                  _buildMenuItem(
                      context,
                      'assets/Cathering.png', // [Image of Cathering Icon]
                      'Konfirmasi Bantuan',
                      const PengelolaPengajuanPage(),
                      ['funder'], // Hanya 'funder' yang diizinkan
                      "Hanya Admin Pemerintah yang dapat mengakses halaman Konfirmasi Bantuan."),
                  _buildMenuItem(
                      context,
                      'assets/ajukan.png', // [Image of Ajukan Sekolah Icon]
                      'Ajukan Sekolah',
                      const PengajuanSekolahPage(),
                      ['school'], // Hanya 'school' dan 'general' yang diizinkan
                      "Hanya Admin Sekolah yang dapat mengakses halaman Ajukan Sekolah."),
                  _buildMenuItem(
                      context,
                      'assets/laporan.png', // [Image of Laporan Icon]
                      'Menu',
                      const MenuHariIni(),
                      [
                        'school',
                        'catering',
                        'funder',
                        'general'
                      ], // Semua peran diizinkan
                      "" // Tidak perlu pesan jika semua bisa akses, atau sesuaikan
                      ),
                  _buildMenuItem(
                      context,
                      'assets/profil.png', // [Image of Profil Icon]
                      'Profil',
                      const ProfilPage(),
                      [
                        'school',
                        'catering',
                        'funder',
                        'general'
                      ], // Semua peran diizinkan
                      "" // Tidak perlu pesan
                      ),
                ],
              ),
            ),
            // Tombol Logout
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                print('Logout button pressed.');
                final AuthService authService = AuthService();
                try {
                  print('Attempting to sign out...');
                  await authService.signOut();
                  print('Sign out successful.');
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                  print('Navigated to Login Page.');
                } catch (e) {
                  print('Error during sign out: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal logout: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF1B1464,
                ),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                minimumSize: const Size(
                  double.infinity,
                  50,
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membangun setiap item menu
  Widget _buildMenuItem(
    BuildContext context,
    String imagePath,
    String label,
    Widget destination,
    List<String> allowedRoles, // Parameter baru: Daftar peran yang diizinkan
    String accessDeniedMessage, // Parameter baru: Pesan ketika akses ditolak
  ) {
    return InkWell(
      onTap: () {
        // Cek apakah peran pengguna saat ini ada di dalam daftar peran yang diizinkan
        if (_userRole != null && allowedRoles.contains(_userRole)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        } else {
          // Jika peran tidak diizinkan, tampilkan pesan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(accessDeniedMessage),
              duration: const Duration(seconds: 2), // Durasi pesan
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal[200], // Warna background lingkaran ikon
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons
                      .broken_image, // Fallback icon jika gambar tidak ditemukan
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[300], // Warna background label
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
