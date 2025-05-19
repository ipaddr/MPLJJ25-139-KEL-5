import 'package:flutter/material.dart';
import 'PemesananSekolahPage.dart'; // pastikan import file halaman tujuan

class JasaCateringPage extends StatelessWidget {
  const JasaCateringPage({super.key});

  final List<String> jasaCateringList = const [
    'Catering A',
    'Catering B',
    'Catering C',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1464),
        title: const Row(
          children: [
            Icon(Icons.school),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Farastika Allitsio", style: TextStyle(fontSize: 16)),
                Text("Laporan Gathering", style: TextStyle(fontSize: 12)),
              ],
            ),
            Spacer(),
            Icon(Icons.home),
            SizedBox(width: 10),
            Icon(Icons.menu),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Jasa Catering",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Cari jasa catering...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.filter_list),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Hasil pencarian untuk: 'Surakarta Barat'",
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: jasaCateringList.length,
                itemBuilder: (context, index) {
                  final namaCatering = jasaCateringList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PemesananSekolahPage(
                                namaCatering: namaCatering,
                              ),
                        ),
                      );
                    },
                    child: CateringCard(namaCatering: namaCatering),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CateringCard extends StatelessWidget {
  final String namaCatering;
  const CateringCard({super.key, required this.namaCatering});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.restaurant, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                namaCatering,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
