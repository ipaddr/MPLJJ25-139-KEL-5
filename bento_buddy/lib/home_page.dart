import 'package:flutter/material.dart';
import 'register_page.dart'; // Import RegisterPage
import 'login_page.dart'; // Import LoginPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Asumsi 'assets/background.png' adalah gambar latar belakang yang ada
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
            // Anda bisa menambahkan errorBuilder di sini untuk debugging jika gambar tidak muncul
            // errorBuilder: (context, error, stackTrace) => Container(color: Colors.red.shade900),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:
                        Colors
                            .white, // Pastikan teks terlihat di latar belakang
                  ),
                ),
                const SizedBox(height: 32),
                // Tombol Login
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke LoginPage menggunakan MaterialPageRoute
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Warna sesuai keinginan
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                // Tombol Register
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke RegisterPage menggunakan MaterialPageRoute
                    // Tombol ini SEHARUSNYA sudah bisa diklik karena onPressed sudah diatur.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Register', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
