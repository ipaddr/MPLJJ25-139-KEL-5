import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1464),
        toolbarHeight: 80,
        title: Row(
          children: [
            const Icon(Icons.school, size: 32, color: Colors.white),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Farastika Allistio",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "Laper'in Cathering",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.menu, color: Colors.white),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Mau cari apa?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Menu Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                children: [
                  _buildMenuItem('assets/menerima.png', 'Menerima Bantuan'),
                  _buildMenuItem(
                    'assets/belum_menerima.png',
                    'Belum Menerima Bantuan',
                  ),
                  _buildMenuItem('assets/gathering.png', 'Gathering'),
                  _buildMenuItem('assets/ajukan.png', 'Ajukan Sekolah'),
                  _buildMenuItem('assets/laporan.png', 'Laporan'),
                  _buildMenuItem('assets/profil.png', 'Profil'),
                ],
              ),
            ),

            // Buttons at bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1464),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Kembali'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: implement logout logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1464),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String imagePath, String label) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal[200],
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(imagePath),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
