import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1752),
        title: const Text('Profil'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Icon profil pengguna
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black12,
              child: Icon(Icons.person, size: 60, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Informasi Instansi
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1752),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoItem(label: 'Nama Instansi', value: 'Laper’in Cathering'),
                  InfoItem(
                    label: 'Alamat',
                    value: 'Jl. Cendrawasih No 21 C Air Tawar Barat',
                  ),
                  InfoItem(label: 'Owner', value: 'Farastika Allistio Putri'),
                  InfoItem(label: 'Kontak', value: '085270707218'),
                  InfoItem(label: 'Email', value: 'lapercathering@gmail.com'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sekolah yang dikelola',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Daftar sekolah
            const SchoolCard(
              name: 'SD N 01 Padang',
              address: 'Jl. Pasir K11 Padang',
              totalPaket: '3 Paket / 1391 porsi/hari',
              since: '01 November 2024',
              imagePath: 'assets/icons/school.png',
            ),
            const SchoolCard(
              name: 'SD N 08 Padang Utara',
              address: 'Jl. Andalas No 13 Padang Utara',
              totalPaket: '1 Paket / 690 porsi/hari',
              since: '21 Desember 2024',
              imagePath: 'assets/icons/school.png',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 14),
          children: [
            TextSpan(
              text: '$label : ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class SchoolCard extends StatelessWidget {
  final String name;
  final String address;
  final String totalPaket;
  final String since;
  final String imagePath;

  const SchoolCard({
    required this.name,
    required this.address,
    required this.totalPaket,
    required this.since,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: const Color(0xFFF2EEEE),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Gambar sekolah
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Informasi sekolah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/icons/school.png', width: 16),
                      const SizedBox(width: 6),
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Image.asset('assets/icons/location.png', width: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset('assets/icons/bento.png', width: 14),
                      const SizedBox(width: 6),
                      Text(totalPaket, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset('assets/icons/calendar.png', width: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Since : $since',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
