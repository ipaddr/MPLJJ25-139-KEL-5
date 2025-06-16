import 'package:flutter/material.dart';
import 'package:bento_buddy/home_page.dart'; // Import HomePage yang baru
import 'register_page.dart'; // Import RegisterPage
import 'package:bento_buddy/services/auth_service.dart'; // Import AuthService

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Mengganti usernameController menjadi emailController agar sesuai dengan Firebase Auth
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService(); // Instance dari AuthService

  // Pastikan untuk membuang controller saat widget dihapus
  @override
  void dispose() {
    emailController.dispose(); // Dispose emailController
    passwordController.dispose();
    super.dispose();
  }

  // Helper method untuk konsistensi gaya InputDecoration
  InputDecoration _inputDecoration(String hintText, {IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey.shade300,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon:
          prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey)
              : null, // Tambahkan prefixIcon
      hintStyle: const TextStyle(color: Colors.grey), // Gaya untuk hint text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // Pastikan aset ini ada
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                0.85,
              ), // Menggunakan .withOpacity()
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Color.fromARGB(
                      255,
                      49,
                      43,
                      43,
                    ), // Warna judul LOGIN (hitam/gelap)
                  ),
                ),
                const SizedBox(height: 24),

                // Email TextField
                TextField(
                  controller: emailController, // Gunakan emailController
                  keyboardType:
                      TextInputType.emailAddress, // Keyboard untuk email
                  decoration: _inputDecoration(
                    'Email',
                    prefixIcon: Icons.email_outlined,
                  ), // Tambahkan ikon email
                ),
                const SizedBox(height: 16),

                // Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(
                    'Password',
                    prefixIcon: Icons.lock_outline,
                  ), // Tambahkan ikon kunci
                ),
                const SizedBox(height: 24),

                // Tombol Login
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Ubah menjadi async
                      final email = emailController.text.trim();
                      final password = passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email dan password wajib diisi'),
                          ),
                        );
                        return;
                      }

                      // Tampilkan loading spinner
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                      );

                      // Panggil fungsi signIn dari AuthService
                      String? errorMessage = await _authService
                          .signInWithEmailPassword(
                            email: email,
                            password: password,
                          );

                      // Sembunyikan loading spinner
                      Navigator.of(context).pop();

                      if (errorMessage == null) {
                        // Login berhasil
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login berhasil!')),
                        );
                        // Navigasi ke halaman HomePage yang baru dan hapus stack navigasi sebelumnya
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const HomePage(), // Mengarahkan ke HomePage
                          ),
                        );
                      } else {
                        // Login gagal, tampilkan pesan error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login gagal: $errorMessage')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF1E2378,
                      ), // Warna background tombol (biru tua)
                      foregroundColor:
                          Colors.white, // Warna teks tombol menjadi putih
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ), // Tambahkan bold agar lebih terlihat
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Spasi di bawah tombol login
                // Tombol "Daftar Sekarang"
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Belum punya akun? Daftar Sekarang',
                    style: TextStyle(
                      color: Colors.blueAccent, // Warna link
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
