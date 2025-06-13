import 'beranda.dart';

import 'package:bento_buddy/splash_screen.dart';
import 'package:flutter/material.dart';
// Pastikan kamu punya file ini

void main() {
  runApp(const BentoBuddy());
}

class BentoBuddy extends StatelessWidget {
  const BentoBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bento Buddy',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const Beranda(),
      },
    );
  }
}
