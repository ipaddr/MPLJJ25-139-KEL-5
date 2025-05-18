import 'package:bento_buddy/nerimabantuan.dart';
import 'package:bento_buddy/pengajuanpage.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'beranda.dart';
import 'nerimabantuan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bento Buddy',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/beranda': (context) => const NerimaBantuan(),
      },
    );
  }
}
