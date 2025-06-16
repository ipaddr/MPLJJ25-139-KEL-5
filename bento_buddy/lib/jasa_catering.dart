import 'package:flutter/material.dart';
import 'laperin_catering.dart'; // Import halaman LaperinCatering
import 'menu.dart'; // Import menu.dart untuk navigasi ke halaman menu

// Definisikan kelas untuk merepresentasikan data Catering
class CateringData {
  final String nama;
  final String logoAssetPath;

  // Pastikan constructor ini const untuk optimasi kinerja
  const CateringData({required this.nama, required this.logoAssetPath});
}

class JasaCateringPage extends StatefulWidget {
  const JasaCateringPage({super.key});

  @override
  State<JasaCateringPage> createState() => _JasaCateringPageState();
}

class _JasaCateringPageState extends State<JasaCateringPage> {
  final TextEditingController _searchController = TextEditingController();
  List<CateringData> semuaCatering = [];
  List<CateringData> hasilPencarian = [];

  @override
  void initState() {
    super.initState();
    // Data catering sesuai dengan gambar
    // Gunakan 'const' di depan List literals jika semua elemen di dalamnya adalah konstanta.
    semuaCatering = const [
      CateringData(
        nama: 'Laper\'in Catering',
        logoAssetPath: 'assets/laper.png',
      ),
      CateringData(
        nama: 'Anande Catering',
        logoAssetPath: 'assets/anande.png',
      ), // Asumsi nama file
      CateringData(
        nama: 'DeLuna Catering',
        logoAssetPath: 'assets/deluna.png',
      ), // Asumsi nama file
      CateringData(
        nama: 'OndeMande Catering',
        logoAssetPath: 'assets/ondemande.png',
      ),
      CateringData(
        nama: 'Golden City Catering',
        logoAssetPath: 'assets/goldencity.png',
      ), // Asumsi nama file
      CateringData(
        nama: 'Rabu\'s Catering',
        logoAssetPath: 'assets/rabus.png',
      ), // Asumsi nama file
      CateringData(
        nama: 'Lezato Catering',
        logoAssetPath: 'assets/lezato.png',
      ), // Asumsi nama file
    ];
    hasilPencarian = semuaCatering;
    _searchController.addListener(_filterCatering);
  }

  void _filterCatering() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      hasilPencarian =
          semuaCatering
              .where((catering) => catering.nama.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hapus tombol back default
        toolbarHeight: 100, // Sesuaikan tinggi
        backgroundColor: const Color(
          0xFF271A5A,
        ), // Warna sesuai AppBar di sekolah.dart
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/logo.png', // Logo utama aplikasi
                height: 50,
                width: 50,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Farastika Allistio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Laper\'in Gathering', // Diselaraskan dengan AppBar lain
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Menu()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Tombol kembali
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Jasa Catering",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSearchBar(), // Menggunakan search bar yang mirip dengan nerimabantuan.dart
            const SizedBox(height: 10),
            if (_searchController.text.isNotEmpty)
              Text(
                "Hasil pencarian untuk: '${_searchController.text}'",
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              )
            else
              const Text(
                "Jasa Catering Yang Tersedia",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: hasilPencarian.length,
                itemBuilder: (context, index) {
                  final catering = hasilPencarian[index];
                  return InkWell(
                    onTap: () {
                      if (catering.nama == 'Laper\'in Catering') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LaperinCatering(),
                          ),
                        );
                      } else {
                        // Untuk catering lain, Anda bisa menampilkan snackbar atau menavigasi ke halaman detail generik
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Anda memilih ${catering.nama}. (Halaman detail belum tersedia)',
                            ),
                          ),
                        );
                        // Atau navigasi ke CateringDetailPage(cateringData: catering) jika Anda membuatnya
                      }
                    },
                    child: CateringCard(
                      cateringData: catering,
                    ), // Meneruskan objek CateringData
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
      ), // Hapus margin horizontal di sini karena sudah ada padding parent
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Warna background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari jasa catering...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list), // Ikon filter
            onPressed: () {
              // Aksi untuk filter
            },
          ),
        ],
      ),
    );
  }
}

class CateringCard extends StatelessWidget {
  final CateringData cateringData; // Menerima objek CateringData

  const CateringCard({super.key, required this.cateringData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Tambahkan border radius
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Warna background ikon
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  cateringData.logoAssetPath, // Menggunakan logo dari data
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.restaurant,
                      color: Colors.grey,
                    ); // Fallback ikon restoran
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                cateringData.nama, // Nama catering dari data
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
