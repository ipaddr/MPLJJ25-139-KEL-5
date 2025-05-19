import 'package:flutter/material.dart';

class Pemesanan {
  final String namaSekolah;
  final String alamat;
  final int jumlahPorsiPerHari;
  final double hargaPerPorsi;
  final String namaCatering;

  Pemesanan({
    required this.namaSekolah,
    required this.alamat,
    required this.jumlahPorsiPerHari,
    required this.hargaPerPorsi,
    required this.namaCatering,
  });

  double get totalAnggaran => jumlahPorsiPerHari * hargaPerPorsi;
}

class PemesananSekolahPage extends StatelessWidget {
  final String namaCatering;

  PemesananSekolahPage({required this.namaCatering});

  final List<Pemesanan> semuaPesanan = [
    Pemesanan(
      namaSekolah: 'SDN 1 Surakarta Barat',
      alamat: 'Jl. Melati No.1',
      jumlahPorsiPerHari: 120,
      hargaPerPorsi: 15000,
      namaCatering: 'Catering A',
    ),
    Pemesanan(
      namaSekolah: 'SMPN 2 Surakarta Barat',
      alamat: 'Jl. Kenanga No.5',
      jumlahPorsiPerHari: 100,
      hargaPerPorsi: 14000,
      namaCatering: 'Catering B',
    ),
    Pemesanan(
      namaSekolah: 'SMAN 3 Surakarta Barat',
      alamat: 'Jl. Mawar No.10',
      jumlahPorsiPerHari: 90,
      hargaPerPorsi: 15000,
      namaCatering: 'Catering A',
    ),
    Pemesanan(
      namaSekolah: 'SDN 4 Surakarta Timur',
      alamat: 'Jl. Anggrek No.3',
      jumlahPorsiPerHari: 80,
      hargaPerPorsi: 16000,
      namaCatering: 'Catering C',
    ),
    Pemesanan(
      namaSekolah: 'SMPN 5 Surakarta Timur',
      alamat: 'Jl. Flamboyan No.7',
      jumlahPorsiPerHari: 70,
      hargaPerPorsi: 15000,
      namaCatering: 'Catering A',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Pemesanan> pesananUntukCatering =
        semuaPesanan.where((p) => p.namaCatering == namaCatering).toList();

    final double totalAnggaranKeseluruhan = pesananUntukCatering.fold(
      0,
      (total, p) => total + p.totalAnggaran,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1464),
        centerTitle: true,
        foregroundColor:
            Colors.white, // Ini akan buat semua teks dan ikon jadi putih
        title: Text(namaCatering),
      ),
      body:
          pesananUntukCatering.isEmpty
              ? const Center(
                child: Text('Belum ada sekolah yang memesan catering ini.'),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: pesananUntukCatering.length,
                      itemBuilder: (context, index) {
                        final sekolah = pesananUntukCatering[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.school,
                                      color: Color(0xFF1B1464),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        sekolah.namaSekolah,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(sekolah.alamat),
                                const SizedBox(height: 8),
                                Text(
                                  "Jumlah porsi per hari: ${sekolah.jumlahPorsiPerHari}",
                                ),
                                Text(
                                  "Harga per porsi: Rp ${sekolah.hargaPerPorsi.toStringAsFixed(0)}",
                                ),
                                Text(
                                  "Total anggaran: Rp ${sekolah.totalAnggaran.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Text(
                      "Total Anggaran Keseluruhan: Rp ${totalAnggaranKeseluruhan.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1B1464),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
