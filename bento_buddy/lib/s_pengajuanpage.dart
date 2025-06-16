import 'package:flutter/material.dart';
import 's_menu.dart'; // Impor untuk navigasi ke menu utama
import 's_notif_ajukan.dart'; // Impor halaman notifikasi pengajuan

class PengajuanPage extends StatefulWidget {
  const PengajuanPage({super.key});

  @override
  State<PengajuanPage> createState() => _PengajuanPageState();
}

class _PengajuanPageState extends State<PengajuanPage> {
  final TextEditingController _namaInstansiController = TextEditingController();
  final TextEditingController _alamatInstansiController =
      TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _namaInstansiController.dispose();
    _alamatInstansiController.dispose();
    _noTelpController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _ajukanPermohonan() {
    // Di sini Anda bisa menambahkan logika untuk mengirim data pengajuan
    // Misalnya, mengirim ke API atau menyimpan ke database
    final String namaInstansi = _namaInstansiController.text;
    final String alamatInstansi = _alamatInstansiController.text;
    final String noTelp = _noTelpController.text;
    final String email = _emailController.text;

    // Contoh: Tampilkan data di konsol
    print('Nama Instansi: $namaInstansi');
    print('Alamat Instansi: $alamatInstansi');
    print('No. Telp: $noTelp');
    print('Email: $email');

    // Navigasi ke halaman notifikasi pengajuan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => const NotifAjukanPage(), // Navigasi ke NotifAjukanPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          100.0,
        ), // Tinggi AppBar yang disesuaikan
        child: AppBar(
          backgroundColor: const Color(0xFF271A5A),
          elevation: 0, // Menghilangkan bayangan AppBar
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Logo aplikasi
                          Image.asset(
                            'assets/logo.png', // Logo utama aplikasi
                            height: 50,
                            width: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons
                                    .fastfood, // Fallback icon jika logo tidak ada
                                color: Colors.white,
                                size: 50,
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          // Informasi pengguna
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
                                'Laper\'in Cathering',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Ikon Menu
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Menu(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Kembali ke halaman sebelumnya
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black, // Warna ikon kembali
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Pengajuan', // Judul halaman
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Sekolah Belum Terdaftar', // Sub-judul
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_namaInstansiController, 'Nama Instansi'),
            const SizedBox(height: 15),
            _buildTextField(_alamatInstansiController, 'Alamat Instansi'),
            const SizedBox(height: 15),
            _buildTextField(_noTelpController, 'No Telp'),
            const SizedBox(height: 15),
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _ajukanPermohonan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF271A5A), // Warna tombol
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Ajukan',
                  style: TextStyle(
                    // Ini adalah perbaikan utama
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membangun TextField
  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Warna background field
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none, // Hapus border default TextField
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
