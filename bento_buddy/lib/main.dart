import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import package Firebase Core
import 'package:bento_buddy/splash_screen.dart';

void main() async {
  // Ubah main menjadi async
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan Flutter binding telah diinisialisasi
  await Firebase.initializeApp(); // Inisialisasi Firebase

  runApp(const BentoBuddy());
}

class BentoBuddy extends StatelessWidget {
  const BentoBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bento Buddy',
      debugShowCheckedModeBanner: false,
      // initialRoute: '/', // Tidak perlu initialRoute jika kita menanganinya di SplashScreen
      home: const SplashScreen(), // Mengatur SplashScreen sebagai halaman awal
      routes: {
        // Halaman lain bisa ditambahkan di sini jika perlu navigasi bernama
        // '/login': (context) => const LoginPage(), // Jika LoginPage adalah halaman terpisah
        // '/home': (context) => const Beranda(), // Contoh rute untuk Beranda
      },
    );
  }
}
