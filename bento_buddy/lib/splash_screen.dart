import 'package:bento_buddy/menu.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return; // ✅ Cegah error karena context tidak valid
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Menu()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Image.asset('assets/logo.png', width: 150, height: 150),
      ),
    );
  }
}
