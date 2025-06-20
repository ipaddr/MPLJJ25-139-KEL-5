import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestoreimport 'pack877age:intl/intl.dart'; // Import untuk format tanggal
import 'package:bento_buddy/menu.dart'; // Import halaman menu untuk navigasi ke sana
import 'package:bento_buddy/upload_menu.dart'; // Asumsikan ada file ini untuk halaman upload menu
import 'package:bento_buddy/menu_data.dart'; // Import model MenuData yang baru

// Definisi CustomHeader lokal untuk halaman ini
class _CustomHeaderForMenu extends StatefulWidget
    implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onBackPressed;
  final String? userName;
  final String? userRoleDisplay;
  final String? userInstitutionName;
  final String? userRole; // <-- ADD THIS LINE

  const _CustomHeaderForMenu({
    required this.onMenuPressed,
    required this.onBackPressed,
    this.userName,
    this.userRoleDisplay,
    this.userInstitutionName,
    this.userRole, // <-- ADD THIS LINE
  });

  @override
  State<_CustomHeaderForMenu> createState() => _CustomHeaderForMenuState();

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}

class _CustomHeaderForMenuState extends State<_CustomHeaderForMenu> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Hapus tombol back default dari AppBar
      backgroundColor: const Color(0xFF271A5A), // Warna AppBar sesuai gambar
      toolbarHeight:
          widget.preferredSize.height, // Menggunakan tinggi yang disesuaikan
      flexibleSpace: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo aplikasi dan info user
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png', // [Image of Logo Aplikasi]
                        height: 50,
                        width: 50,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.restaurant,
                          color: Colors.white,
                          size: 50,
                        ), // Fallback
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName ??
                                'Pengguna', // Nama pengguna dinamis
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.userInstitutionName ??
                                widget.userRoleDisplay ??
                                'BentoBuddy User', // Instansi atau peran dinamis
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Ikon Chatbot (if you added it)
                  // Uncomment if ChatbotPage exists and you want the icon
                  /*
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatbotPage()),
                      );
                    },
                  ),
                  */
                  // Ikon menu
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
            const SizedBox(height: 10), // Spasi di bawah info user
            // Baris kedua AppBar: Tombol kembali, judul "Menu Hari Ini", dan "Upload Menu"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget
                        .onBackPressed, // Memanggil callback onBackPressed
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Menu Hari Ini',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Bagian "Upload Menu"
                  GestureDetector(
                    onTap: () {
                      // Check user role before navigating
                      if (widget.userRole == 'catering') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UploadMenuPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Hanya Admin Catering yang dapat mengunggah menu.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Upload Menu',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class MenuHariIni extends StatefulWidget {
  const MenuHariIni({super.key});

  @override
  State<MenuHariIni> createState() => _MenuHariIniState();
}

class _MenuHariIniState extends State<MenuHariIni> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<MenuData> _allMenusData = []; // Menggunakan model MenuData
  List<MenuData> _filteredMenusData = [];
  Map<String, String> _cateringsMap = {};

  String? _userName;
  String? _userRole; // <-- Store the actual user role here
  String? _userRoleDisplay;
  String? _userInstitutionName;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_filterMenu);
  }

  Future<void> _loadInitialData() async {
    // Memuat data pengguna untuk header
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = data['name'];
          _userRole = data['role']; // <-- Assign the role
          _userInstitutionName = data['institutionName'];
          _userRoleDisplay = _mapRoleToDisplay(data['role']);
        });
      }
    }

    // Mendengarkan perubahan pada koleksi 'menus'
    _firestore
        .collection('menus')
        .orderBy('timestamp',
            descending: true) // Urutkan berdasarkan waktu upload terbaru
        .snapshots()
        .listen((snapshot) {
      List<MenuData> loadedMenus =
          snapshot.docs.map((doc) => MenuData.fromFirestore(doc)).toList();
      setState(() {
        _allMenusData = loadedMenus;
        _filterMenu(); // Terapkan filter setelah data dimuat/diperbarui
      });
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading menus: $error')),
      );
    });
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

  void _filterMenu() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMenusData = _allMenusData
          .where(
            (menu) =>
                menu.menuName.toLowerCase().contains(query) ||
                menu.cateringName.toLowerCase().contains(query) ||
                menu.description.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Warna latar belakang keseluruhan
      appBar: _CustomHeaderForMenu(
        // Menggunakan CustomHeader khusus untuk menu
        userName: _userName,
        userRoleDisplay: _userRoleDisplay,
        userInstitutionName: _userInstitutionName,
        userRole: _userRole, // <-- PASS THE USER ROLE HERE
        onMenuPressed: () {
          // Aksi untuk ikon menu di header (menampilkan bottom sheet)
        },
        onBackPressed: () {
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            _buildSearchBar(),
            const SizedBox(height: 16),
            // Daftar menu per katering
            Expanded(
              child: _allMenusData.isEmpty && _filteredMenusData.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator()) // Tampilkan loading
                  : ListView.builder(
                      itemCount: _getCateringNames(_filteredMenusData).length,
                      itemBuilder: (context, index) {
                        final cateringName =
                            _getCateringNames(_filteredMenusData)[index];
                        final menusForCatering = _filteredMenusData
                            .where((menu) => menu.cateringName == cateringName)
                            .toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                cateringName, // Nama Katering
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF271A5A),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // Menonaktifkan scroll ListView internal
                              itemCount: menusForCatering.length,
                              itemBuilder: (context, subIndex) {
                                final menu = menusForCatering[subIndex];
                                return MenuItemCard(
                                    menu: menu); // Menggunakan MenuItemCard
                              },
                            ),
                            const SizedBox(height: 20), // Spasi antar katering
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membangun search bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Warna background search bar
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.search,
              color: Colors.grey), // [Image of Search Icon]
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari menu...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list,
                color: Colors.grey), // [Image of Filter Icon]
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

  // Helper untuk mendapatkan daftar nama katering unik dari MenuData
  List<String> _getCateringNames(List<MenuData> menus) {
    return menus.map((m) => m.cateringName).toSet().toList();
  }
}

// Widget untuk menampilkan setiap item menu dalam Card
class MenuItemCard extends StatelessWidget {
  final MenuData menu; // Menggunakan model MenuData

  const MenuItemCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(bottom: 12), // Margin bawah untuk setiap card
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // Sudut membulat
      elevation: 1, // Sedikit bayangan
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Penataan item ke atas
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // Sudut gambar membulat
              child: Image.network(
                // Menggunakan Image.network untuk URL gambar
                menu.imageUrl, // URL gambar dari MenuData
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons
                        .broken_image, // Fallback icon jika gambar tidak ditemukan atau gagal dimuat
                    size: 80,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const SizedBox(width: 15), // Spasi horizontal
            Expanded(
              // Penting: Expanded agar teks tidak overflow
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Penataan kolom ke kiri
                children: [
                  Text(
                    menu.menuName, // Nama Menu
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    menu.description, // Deskripsi Menu
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 3, // Batasi jumlah baris deskripsi
                    overflow: TextOverflow
                        .ellipsis, // Tambahkan "..." jika terlalu panjang
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Diunggah: ${menu.formattedDate}', // Tanggal unggah
                    style:
                        const TextStyle(fontSize: 10, color: Colors.blueGrey),
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
