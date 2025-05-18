import 'package:flutter/material.dart';

class LaperinCatering extends StatelessWidget {
  const LaperinCatering({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1464),
        title: Row(
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
            Text(
              "Laper'in Catering",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Cari sekolah...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.filter_list),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Daftar Sekolah'",
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => SchoolCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SchoolCard extends StatelessWidget {
  const SchoolCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(height: 40, width: 40, color: Colors.grey[300]),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, color: Colors.grey[300]),
                  SizedBox(height: 6),
                  Container(height: 12, width: 100, color: Colors.grey[300]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
