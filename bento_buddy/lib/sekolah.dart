import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

// Definisi kelas Sekolah (Model)
// Ini adalah definisi tunggal untuk model Sekolah
class Sekolah {
  final String id;
  final String nama;
  final String alamat;
  final String? cateringName; // Nama catering yang terkait
  final String totalPorsi; // Total porsi harian
  final String tanggalKonfirmasi; // Tanggal konfirmasi/penerimaan sekolah
  final String? logoPath; // Path logo sekolah

  // Tambahan field untuk detail sekolah yang lebih spesifik
  // Jika ini ada di Firestore, pastikan namanya sesuai.
  // Jika tidak, Anda bisa menghapusnya atau menyediakan fallback.
  final String? kepalaSekolah;
  final String? kontakSekolah;
  final String? emailSekolah;
  final String?
      totalDanaBantuan; // Misal dari field di Firestore 'totalFinancialAid'

  Sekolah({
    required this.id,
    required this.nama,
    required this.alamat,
    this.cateringName,
    required this.totalPorsi,
    required this.tanggalKonfirmasi,
    this.logoPath,
    this.kepalaSekolah,
    this.kontakSekolah,
    this.emailSekolah,
    this.totalDanaBantuan,
  });

  // Factory constructor untuk membuat objek Sekolah dari DocumentSnapshot Firestore
  factory Sekolah.fromFirestore(
    DocumentSnapshot doc,
    Map<String, String> cateringsMap,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    String? assignedCateringId = data['assignedCateringId'];
    String? resolvedCateringName =
        assignedCateringId != null ? cateringsMap[assignedCateringId] : null;

    String formattedDate = 'Belum ada konfirmasi';
    // Menggunakan 'confirmedDate' sebagai field tanggal konfirmasi
    if (data['confirmedDate'] is Timestamp) {
      DateTime dateTime = (data['confirmedDate'] as Timestamp).toDate();
      formattedDate =
          'dikonfirmasi sejak ${DateFormat('dd MMMM HH:mm').format(dateTime)}';
    } else if (data['createdAt'] is Timestamp &&
        (data['confirmedDate'] == null ||
            !(data['confirmedDate'] is Timestamp))) {
      // Fallback: Jika confirmedDate tidak ada, tapi createdAt ada, gunakan itu
      DateTime dateTime = (data['createdAt'] as Timestamp).toDate();
      formattedDate =
          'dibuat pada ${DateFormat('dd MMMM HH:mm').format(dateTime)}';
    }

    return Sekolah(
      id: doc.id,
      nama: data['schoolName'] ?? 'Nama Sekolah Tidak Tersedia',
      alamat: data['location'] ?? 'Alamat Tidak Tersedia',
      cateringName: resolvedCateringName,
      totalPorsi: '${data['totalAidReceived'] ?? 0} Porsi/hari',
      tanggalKonfirmasi: formattedDate,
      logoPath: data['logoPath'] ?? 'assets/school_building.png',

      // Mengambil data tambahan (pastikan field ini ada di Firestore jika ingin dinamis)
      kepalaSekolah: data['kepalaSekolah'] ?? 'Tidak Tersedia',
      kontakSekolah: data['kontakSekolah'] ?? 'Tidak Tersedia',
      emailSekolah: data['emailSekolah'] ?? 'Tidak Tersedia',
      totalDanaBantuan: data['totalDanaBantuan'] != null
          ? 'Rp. ${NumberFormat("#,##0", "id_ID").format(data['totalDanaBantuan'])} / Bulan'
          : 'Tidak Tersedia',
    );
  }
}

// Halaman Detail Sekolah
class SekolahPage extends StatelessWidget {
  final Sekolah sekolahData;

  const SekolahPage({super.key, required this.sekolahData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Menampilkan tombol kembali otomatis
        automaticallyImplyLeading: true,
        toolbarHeight: 100,
        backgroundColor: const Color(0xFF271A5A),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/logo.png', // Logo utama aplikasi
                height: 50,
                width: 50,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 50,
                  ); // Fallback icon
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sekolahData.nama, // Nama sekolah dari data dinamis
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  sekolahData.alamat, // Alamat sekolah dari data dinamis
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu dari SekolahPage ditekan!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Detail ${sekolahData.nama}', // Teks judul halaman
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Image.asset(
                sekolahData.logoPath ??
                    'assets/school_building.png', // Menggunakan logoPath dari objek sekolahData
                height: 200,
                width: 300,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/school_building.png', // Gambar default jika logo sekolah tidak ada
                    height: 200,
                    width: 300,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF271A5A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  _buildDetailRow('Nama Instansi', sekolahData.nama),
                  _buildDetailRow('Alamat', sekolahData.alamat),
                  _buildDetailRow(
                    'Tanggal Konfirmasi',
                    sekolahData.tanggalKonfirmasi,
                  ), // Tanggal konfirmasi
                  _buildDetailRow(
                    'Kepala Sekolah',
                    sekolahData.kepalaSekolah ?? 'Tidak Tersedia',
                  ),
                  _buildDetailRow(
                    'Kontak',
                    sekolahData.kontakSekolah ?? 'Tidak Tersedia',
                  ),
                  _buildDetailRow(
                    'Email',
                    sekolahData.emailSekolah ?? 'Tidak Tersedia',
                  ),
                  _buildDetailRow(
                    'Total Dana',
                    sekolahData.totalDanaBantuan ?? 'Tidak Tersedia',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Icons.email, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon Email ditekan!')),
                  );
                }),
                _buildSocialIcon(Icons.message, () {
                  // Menggunakan Icons.message sebagai alternatif WhatsApp
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon WhatsApp ditekan!')),
                  );
                }),
                _buildSocialIcon(Icons.camera_alt, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon Instagram ditekan!')),
                  );
                }),
                _buildSocialIcon(Icons.send, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ikon Telegram ditekan!')),
                  );
                }),
              ],
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Catering',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Tampilkan hanya satu Catering Card yang terkait dengan sekolah ini
            if (sekolahData.cateringName != null)
              _buildCateringCard(
                context,
                sekolahData.logoPath ??
                    'assets/ajukan.png', // Gunakan logo sekolah atau fallback untuk catering card
                sekolahData.cateringName!, // Nama catering dari data dinamis
                sekolahData
                    .alamat, // Alamat sekolah untuk catering (jika tidak ada alamat spesifik catering)
                sekolahData.totalPorsi, // Total porsi dari data dinamis
                sekolahData
                    .tanggalKonfirmasi, // Tanggal konfirmasi dari data dinamis
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Catering belum ditugaskan untuk sekolah ini.',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const Text(':', style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSocialIcon(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0E0E0),
          ),
          child: Icon(icon, color: const Color(0xFF271A5A), size: 24),
        ),
      ),
    );
  }

  static Widget _buildCateringCard(
    BuildContext context,
    String logoAsset,
    String name,
    String address,
    String total,
    String since,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              logoAsset, // Menggunakan logo sekolah atau logo catering jika ada field terpisah
              height: 60,
              width: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.grey,
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  address,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.people, size: 16, color: Colors.red),
                    const SizedBox(width: 5),
                    Text(
                      'Total : $total',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Since : $since',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
