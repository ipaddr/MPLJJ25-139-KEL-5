import 'package:flutter/material.dart';

class UProfilPage extends StatelessWidget {
  const UProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang keseluruhan halaman
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1752), // Warna AppBar
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ), // Judul AppBar dengan warna dan bold
        ),
        centerTitle: true, // Pusatkan judul
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // Tombol kembali dengan warna putih
          onPressed:
              () =>
                  Navigator.pop(context), // Aksi kembali ke halaman sebelumnya
        ),
      ),
      body: SingleChildScrollView(
        // Memungkinkan halaman untuk discroll jika konten melebihi tinggi layar
        child: Column(
          children: [
            const SizedBox(height: 20), // Spasi vertikal
            // Icon profil pengguna
            const CircleAvatar(
              radius: 50, // Ukuran avatar
              backgroundColor: Colors.black12, // Warna latar belakang avatar
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.black54,
              ), // Ikon orang di dalam avatar
            ),
            const SizedBox(height: 20), // Spasi vertikal
            // Informasi Instansi dalam sebuah Container berwarna
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ), // Margin horizontal
              padding: const EdgeInsets.all(16), // Padding internal
              decoration: BoxDecoration(
                color: const Color(
                  0xFF1F1752,
                ), // Warna latar belakang container
                borderRadius: BorderRadius.circular(12), // Sudut membulat
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Penataan kolom ke kiri
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
            const SizedBox(height: 24), // Spasi vertikal
            // Judul "Sekolah yang dikelola"
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ), // Padding horizontal
              child: Align(
                alignment: Alignment.centerLeft, // Penataan teks ke kiri
                child: Text(
                  'Sekolah yang dikelola',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ), // Gaya teks
                ),
              ),
            ),
            const SizedBox(height: 8), // Spasi vertikal
            // Daftar sekolah yang dikelola (menggunakan data dummy)
            // Setiap SchoolCard akan menampilkan informasi satu sekolah
            SchoolCard(
              name: 'SD N 01 Padang',
              address: 'Jl. Pasir K11 Padang',
              totalPaket: '3 Paket / 1391 porsi/hari',
              since: '01 November 2024',
              imagePath: 'assets/sekolah.png', // Path gambar sekolah
            ),
            SchoolCard(
              name: 'SD N 08 Padang Utara',
              address: 'Jl. Andalas No 13 Padang Utara',
              totalPaket: '690 porsi/hari',
              since: '21 Desember 2024',
              imagePath: 'assets/sekolah.png', // Path gambar sekolah
            ),
            const SizedBox(height: 20), // Spasi vertikal di bagian bawah
          ],
        ),
      ),
    );
  }
}

// Widget untuk menampilkan satu baris informasi (Label: Value)
class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // Padding vertikal
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Penataan ke atas
        children: [
          SizedBox(
            width: 120, // Lebar tetap untuk label agar rapi
            child: Text(
              '$label : ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4), // Spasi horizontal
          Expanded(
            // Penting: Menggunakan Expanded untuk mencegah teks overflow
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow:
                  TextOverflow
                      .ellipsis, // Menambahkan "..." jika teks terlalu panjang
              maxLines: 2, // Membatasi teks maksimal 2 baris
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk menampilkan kartu informasi sekolah yang dikelola
class SchoolCard extends StatelessWidget {
  final String name;
  final String address;
  final String totalPaket;
  final String since;
  final String imagePath; // Path gambar sekolah

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
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ), // Margin card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Sudut membulat
      elevation: 2, // Efek bayangan
      color: const Color(0xFFF2EEEE), // Warna latar belakang card
      child: Padding(
        padding: const EdgeInsets.all(12), // Padding internal card
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Penataan item ke atas
          children: [
            // Gambar sekolah
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // Sudut gambar membulat
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover, // Mode penyesuaian gambar
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika gambar tidak dapat dimuat
                  return const Icon(
                    Icons.broken_image, // Ikon gambar rusak
                    size: 60,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const SizedBox(width: 12), // Spasi horizontal
            // Informasi sekolah (Nama, Alamat, Total Paket, Sejak)
            Expanded(
              // Penting: Menggunakan Expanded agar kolom informasi tidak overflow
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Penataan kolom ke kiri
                children: [
                  Row(
                    children: [
                      // Ikon gedung sekolah (gunakan aset atau fallback ikon)
                      Image.asset(
                        'assets/gedung.png', // Contoh: 'assets/gedung.png' atau 'assets/school_building.png'
                        width: 16,
                        height: 16,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.apartment,
                              size: 16,
                              color: Colors.grey,
                            ), // Fallback ikon
                      ),
                      const SizedBox(width: 6), // Spasi horizontal
                      Expanded(
                        // Expanded untuk nama sekolah
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1, // Hanya satu baris
                          overflow: TextOverflow.ellipsis, // Menambahkan "..."
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2), // Spasi vertikal
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Penataan ke atas
                    children: [
                      // Ikon lokasi (gunakan aset atau fallback ikon)
                      Image.asset(
                        'assets/lokasi.png', // Contoh: 'assets/lokasi.png'
                        width: 14,
                        height: 14,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ), // Fallback ikon
                      ),
                      const SizedBox(width: 6), // Spasi horizontal
                      Expanded(
                        // Expanded untuk alamat
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2, // Maksimal 2 baris
                          overflow: TextOverflow.ellipsis, // Menambahkan "..."
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4), // Spasi vertikal
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 14,
                        color: Colors.grey,
                      ), // Ikon orang
                      const SizedBox(width: 6), // Spasi horizontal
                      Expanded(
                        // Expanded untuk total paket
                        child: Text(
                          totalPaket,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        size: 14,
                        color: Colors.grey,
                      ), // Ikon tanggal
                      const SizedBox(width: 6), // Spasi horizontal
                      Expanded(
                        // Expanded untuk tanggal since
                        child: Text(
                          'Since : $since',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
