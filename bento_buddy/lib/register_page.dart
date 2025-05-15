import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background shapes (you can replace these with Image.asset for more precise shape)
            Positioned(top: 0, left: 0, child: _abstractTopLeft()),
            Positioned(bottom: 0, right: 0, child: _abstractBottomRight()),
            Positioned(top: 20, right: 20, child: _circleDeco()),
            Positioned(bottom: 20, left: 20, child: _circleDeco()),

            // Form content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ...List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[300],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Submit"),
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

  // Decorative shapes
  Widget _abstractTopLeft() => Container(
    width: 100,
    height: 100,
    decoration: const BoxDecoration(
      color: Color(0xFF002E6E), // dark blue
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
    ),
  );

  Widget _abstractBottomRight() => Container(
    width: 100,
    height: 100,
    decoration: const BoxDecoration(
      color: Color(0xFF002E6E),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
    ),
  );

  Widget _circleDeco() => Row(
    children: const [
      Icon(Icons.circle, size: 10, color: Colors.orange),
      SizedBox(width: 4),
      Icon(Icons.circle, size: 10, color: Colors.green),
    ],
  );
}
