import 'package:flutter/material.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String? selectedSchool;
  final List<String> schoolOptions = ['SD N 01 Padang', 'SD N 08 Padang Utara'];

  final TextEditingController porsiController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  void calculateTotal() {
    final int porsi = int.tryParse(porsiController.text) ?? 0;
    final int harga = int.tryParse(hargaController.text) ?? 0;
    totalController.text = (porsi * harga).toString();
  }

  @override
  void dispose() {
    porsiController.dispose();
    hargaController.dispose();
    totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),

            // Tombol back & Judul
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Laporan\nCathering Bulanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Dropdown Pilih Sekolah
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        hintText: 'Pilih Sekolah',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: selectedSchool,
                      items:
                          schoolOptions.map((school) {
                            return DropdownMenuItem(
                              value: school,
                              child: Text(school),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSchool = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Input Jumlah Porsi, Harga, dan Total
                    CustomTextField(
                      label: 'Jumlah Porsi per Bulan',
                      controller: porsiController,
                      onChanged: (_) => calculateTotal(),
                      keyboardType: TextInputType.number,
                    ),
                    CustomTextField(
                      label: 'Harga per Porsi',
                      controller: hargaController,
                      onChanged: (_) => calculateTotal(),
                      keyboardType: TextInputType.number,
                    ),
                    CustomTextField(
                      label: 'Total Harga',
                      controller: totalController,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 8),
                    // Upload Bukti Anggaran
                    UploadSection(label: 'Upload Bukti Anggaran'),

                    // Upload Dokumentasi
                    UploadSection(label: 'Upload Dokumentasi Pengantaran'),

                    const SizedBox(height: 24),

                    // Tombol Submit
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Kirim logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Kirim'),
                      ),
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
}

class UploadSection extends StatelessWidget {
  final String label;

  const UploadSection({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.attach_file),
              SizedBox(width: 8),
              Text('Pilih File'),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2378),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
      ),
      child: Row(
        children: [
          const Icon(Icons.book, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
            'Farastika Allistio\nLaper\'in Catering',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.readOnly = false,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.grey.shade300,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
