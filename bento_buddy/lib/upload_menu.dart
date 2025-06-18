import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk mendapatkan user saat ini
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk menyimpan data menu
import 'package:firebase_storage/firebase_storage.dart'; // Untuk mengunggah gambar
import 'package:image_picker/image_picker.dart'; // Untuk memilih gambar
import 'dart:io'; // Untuk tipe File
import 'notif_menu.dart'; // Import NotifMenuPage
import 'package:bento_buddy/services/auth_service.dart'; // Import AuthService untuk logout
import 'package:bento_buddy/login_page.dart'; // Import LoginPage untuk navigasi logout
import 'package:bento_buddy/menu.dart'; // Import menu.dart untuk navigasi dari bottom sheet

// CustomHeader yang disatukan langsung ke dalam file upload_menu.dart
class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final String? userName;
  final String? userRoleDisplay;
  final String? userInstitutionName;

  const CustomHeader({
    super.key,
    required this.onMenuPressed,
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
                  'assets/logo.png', // Pastikan aset ini ada
                  width: 32,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) {
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
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.home),
                            title: const Text('Beranda'),
                            onTap: () {
                              Navigator.pop(context);
                              // Kembali ke halaman utama (HomePage)
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.restaurant_menu),
                            title: const Text('Menu Hari Ini'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Menu()),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () async {
                              Navigator.pop(context);
                              final AuthService authService = AuthService();
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UploadMenuPage extends StatefulWidget {
  const UploadMenuPage({super.key});

  @override
  State<UploadMenuPage> createState() => _UploadMenuPageState();
}

class _UploadMenuPageState extends State<UploadMenuPage> {
  final TextEditingController _namaMenuController = TextEditingController();
  final TextEditingController _deskripsiMenuController =
      TextEditingController();
  File? _pickedImage; // Untuk menyimpan gambar yang dipilih

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? _cateringId;
  String? _cateringName; // Untuk menyimpan nama instansi catering
  String? _userName; // Untuk CustomHeader
  String? _userRoleDisplay; // Untuk CustomHeader
  String? _userInstitutionName; // Untuk CustomHeader

  @override
  void initState() {
    super.initState();
    _loadCateringData(); // Memuat data catering saat initState
  }

  // Fungsi untuk memuat data pengguna dan catering yang login
  Future<void> _loadCateringData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = data['name']; // Untuk header
          _userInstitutionName = data['institutionName']; // Untuk header
          _userRoleDisplay = _mapRoleToDisplay(data['role']); // Untuk header

          if (data['role'] == 'catering') {
            _cateringId =
                currentUser.uid; // Menggunakan UID user sebagai cateringId
            // Mengambil nama catering dari dokumen user.institutionName
            _cateringName = data['institutionName'];
          } else {
            // Jika bukan catering, mungkin tampilkan pesan error atau redirect
            _cateringId = null;
            _cateringName = null;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Anda tidak memiliki izin untuk mengunggah menu sebagai catering.')),
            );
            // Redirect jika tidak memiliki izin
            Navigator.of(context)
                .pop(); // Contoh: kembali ke halaman sebelumnya
          }
        });
      }
    } else {
      // Jika tidak ada user login, redirect ke halaman login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  // Helper untuk memetakan role ke display name (dari AuthService)
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

  // Fungsi untuk memilih gambar dari galeri/kamera
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  // Fungsi untuk mengunggah menu ke Firebase
  Future<void> _submitMenu() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon unggah gambar menu.')),
      );
      return;
    }
    if (_namaMenuController.text.isEmpty ||
        _deskripsiMenuController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama menu dan deskripsi wajib diisi.')),
      );
      return;
    }
    if (_cateringId == null || _cateringName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Data catering tidak ditemukan. Mohon coba lagi atau hubungi admin.')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Unggah Gambar ke Firebase Storage
      String fileName =
          'menu_images/${DateTime.now().millisecondsSinceEpoch}_${_auth.currentUser!.uid}.png';
      UploadTask uploadTask =
          _storage.ref().child(fileName).putFile(_pickedImage!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // 2. Simpan Data Menu ke Firestore
      await _firestore.collection('menus').add({
        'menuName': _namaMenuController.text.trim(),
        'description': _deskripsiMenuController.text.trim(),
        'imageUrl': imageUrl,
        'cateringId': _cateringId, // ID catering yang mengunggah
        'cateringName': _cateringName, // Nama catering yang mengunggah
        'uploadedByUid': _auth.currentUser!.uid, // UID pengguna yang mengunggah
        'timestamp': Timestamp.now(), // Waktu unggah
        // Tambahan: Anda mungkin ingin menambahkan field seperti 'availableDate', 'price', dll.
      });

      Navigator.of(context).pop(); // Tutup loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu berhasil diunggah!')),
      );

      // Navigasi ke NotifMenuPage setelah berhasil
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NotifMenuPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      Navigator.of(context).pop(); // Tutup loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah menu: $e')),
      );
    }
  }

  @override
  void dispose() {
    _namaMenuController.dispose();
    _deskripsiMenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              // Menggunakan CustomHeader yang ada di file ini
              userName: _userName,
              userRoleDisplay: _userRoleDisplay,
              userInstitutionName: _userInstitutionName,
              onMenuPressed: () {
                // Aksi untuk menu di dalam CustomHeader
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Form Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Area Unggah Gambar
                    GestureDetector(
                      onTap:
                          _pickImage, // Panggil fungsi pilih gambar saat di-tap
                      child: Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                          image: _pickedImage != null
                              ? DecorationImage(
                                  image: FileImage(_pickedImage!),
                                  fit: BoxFit.cover,
                                )
                              : null, // Tampilkan gambar jika sudah dipilih
                        ),
                        child: _pickedImage == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.image,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade600,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Ketuk untuk mengunggah gambar',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            : null, // Jika gambar sudah ada, tidak perlu ikon lagi
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Nama Menu
                    const Text(
                      'Nama Menu :',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _namaMenuController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi
                    const Text(
                      'Deskripsi :',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _deskripsiMenuController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tombol Kirim
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _submitMenu, // Panggil fungsi submit menu
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E2378),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          'Kirim',
                          style: TextStyle(color: Colors.white),
                        ),
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
