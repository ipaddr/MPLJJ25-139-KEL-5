import 'package:flutter/material.dart';
import 'notif_register.dart'; // Import NotifRegisterPage untuk navigasi setelah register
import 'login_page.dart'; // Import LoginPage untuk navigasi kembali ke halaman login

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? selectedStatus;
  bool _obscureText = true; // State untuk mengontrol visibilitas password

  final List<String> statuses = [
    'Admin Sekolah',
    'Admin Catering',
    'Admin Pemerintah',
    'Umum',
  ];

  // Controllers untuk setiap TextFormField
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController institutionNameController =
      TextEditingController();
  final TextEditingController institutionAddressController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Pastikan untuk membuang controller saat widget dihapus untuk mencegah memory leaks
  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    institutionNameController.dispose();
    institutionAddressController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Helper method untuk konsistensi gaya InputDecoration pada TextFormField
  InputDecoration _inputDecoration({
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText, // Teks placeholder
      filled: true, // Mengisi latar belakang TextField
      fillColor: Colors.grey.shade200, // Warna latar belakang TextField
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ), // Padding konten
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Sudut membulat pada border
        borderSide: BorderSide.none, // Menghilangkan garis border
      ),
      prefixIcon:
          prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey)
              : null, // Ikon di awal input
      suffixIcon:
          suffixIcon, // Ikon di akhir input (digunakan untuk toggle password)
      hintStyle: const TextStyle(color: Colors.grey), // Gaya untuk teks hint
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengatur latar belakang halaman dengan gambar
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ), // Padding horizontal untuk konten
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // Pastikan aset ini ada
            fit: BoxFit.cover, // Gambar menutupi seluruh area
          ),
        ),
        child: SafeArea(
          // Memastikan konten tidak tumpang tindih dengan status bar atau notch
          child: SingleChildScrollView(
            // Memungkinkan halaman untuk discroll jika konten melebihi tinggi layar
            child: Column(
              children: [
                const SizedBox(height: 40), // Spasi di bagian atas
                // Tombol kembali (Ikon panah kiri) - Sudah ada dan berfungsi
                Align(
                  alignment: Alignment.centerLeft, // Pusatkan ikon ke kiri
                  child: GestureDetector(
                    onTap: () {
                      // Navigasi kembali ke LoginPage.
                      // pushAndRemoveUntil digunakan untuk menghapus semua rute sebelumnya
                      // sehingga pengguna tidak bisa kembali ke register_page setelah login.
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (Route<dynamic> route) =>
                            false, // Hapus semua rute dari stack
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back_ios, // Ikon panah kiri
                      color:
                          Colors
                              .white, // Warna ikon agar terlihat di latar belakang
                      size: 28, // Ukuran ikon
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Spasi setelah tombol kembali
                // Judul Halaman "REGISTER"
                const Align(
                  alignment: Alignment.centerLeft, // Pusatkan teks ke kiri
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 28, // Ukuran font
                      fontWeight: FontWeight.bold, // Gaya teks bold
                      decoration: TextDecoration.underline, // Garis bawah
                      color: Color.fromARGB(
                        255,
                        16,
                        4,
                        68,
                      ), // Warna teks (biru tua, kontras dengan putih)
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Spasi setelah judul
                // Input Field: Status (Dropdown)
                DropdownButtonFormField<String>(
                  value: selectedStatus, // Nilai yang dipilih
                  hint: const Text(
                    'Status',
                    style: TextStyle(color: Colors.grey),
                  ), // Teks hint
                  items:
                      statuses.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus =
                          value; // Perbarui state saat nilai berubah
                    });
                  },
                  decoration: _inputDecoration(
                    prefixIcon: Icons.person_outline,
                  ), // Menggunakan helper Decoration
                ),
                const SizedBox(height: 12),

                // Input Field: Nama Lengkap
                TextFormField(
                  controller:
                      nameController, // Controller untuk mengambil input
                  decoration: _inputDecoration(
                    hintText: 'Nama Lengkap',
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 12),

                // Input Field: Nomor Identitas
                TextFormField(
                  controller: idController,
                  decoration: _inputDecoration(
                    hintText: 'Nomor Identitas',
                    prefixIcon: Icons.credit_card,
                  ),
                  keyboardType:
                      TextInputType.number, // Mengatur keyboard hanya angka
                ),
                const SizedBox(height: 12),

                // Input Field: Nama Instansi (Hanya tampil jika status bukan 'Umum')
                if (selectedStatus != 'Umum' && selectedStatus != null)
                  Column(
                    children: [
                      TextFormField(
                        controller: institutionNameController,
                        decoration: _inputDecoration(
                          hintText: 'Nama Instansi',
                          prefixIcon: Icons.business,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Input Field: Alamat Instansi (Hanya tampil jika status bukan 'Umum')
                if (selectedStatus != 'Umum' && selectedStatus != null)
                  Column(
                    children: [
                      TextFormField(
                        controller: institutionAddressController,
                        decoration: _inputDecoration(
                          hintText: 'Alamat Instansi',
                          prefixIcon: Icons.location_on_outlined,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Input Field: Username
                TextFormField(
                  controller: usernameController,
                  decoration: _inputDecoration(
                    hintText: 'Username',
                    prefixIcon: Icons.account_circle_outlined,
                  ),
                ),
                const SizedBox(height: 12),

                // Input Field: Password
                TextFormField(
                  controller: passwordController,
                  obscureText:
                      _obscureText, // Menggunakan state untuk visibilitas password
                  decoration: _inputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off
                            : Icons
                                .visibility, // Ikon berubah (mata tertutup/terbuka)
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText =
                              !_obscureText; // Toggle visibilitas password
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Register
                Align(
                  alignment: Alignment.centerRight, // Pusatkan tombol ke kanan
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Tambahkan logika registrasi yang sebenarnya di sini.
                      // Misalnya, validasi input, panggil API pendaftaran, dll.

                      // Setelah proses registrasi (dummy) berhasil:
                      // Navigasi ke NotifRegisterPage dan hapus semua rute sebelumnya
                      // agar pengguna tidak bisa kembali ke halaman register dari notifikasi.
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifRegisterPage(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF1E2378,
                      ), // Warna latar belakang tombol
                      foregroundColor: Colors.white, // Warna teks tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Sudut membulat tombol
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    ), // Teks tombol
                  ),
                ),
                const SizedBox(height: 40), // Spasi di bagian bawah
              ],
            ),
          ),
        ),
      ),
    );
  }
}
