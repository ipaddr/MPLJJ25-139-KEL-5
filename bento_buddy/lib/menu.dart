import 'package:flutter/material.dart';
// Import halaman-halaman tujuan
import 'nerimabantuan.dart';
import 'blmnerimabantuan.dart';
import 'jasa_catering.dart';
import 'pengajuanpage.dart';
import 'laporan.dart';
import 'profil.dart';

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

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                children: [
                  _buildMenuItem(
                    context,
                    'assets/menerima.png',
                    'Menerima Bantuan',
                    const DataSekolahPage(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/belum_menerima.png',
                    'Belum Menerima Bantuan',
                    const Blmnerimabantuan(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/cathering.png',
                    'Cathering',
                    const JasaCateringPage(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/ajukan.png',
                    'Ajukan Sekolah',
                    const PengajuanSekolahPage(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/laporan.png',
                    'Laporan',
                    const LaporanPage(),
                  ),
                  _buildMenuItem(
                    context,
                    'assets/profil.png',
                    'Profil',
                    const ProfilPage(),
                  ),
                ],
              ),
            ),

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

  Widget _buildMenuItem(
    BuildContext context,
    String imagePath,
    String label,
    Widget destination,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal[200],
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
