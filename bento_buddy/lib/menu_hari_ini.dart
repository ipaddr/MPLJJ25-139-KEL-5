import 'package:flutter/material.dart';

class MenuHariIniPage extends StatelessWidget {
  const MenuHariIniPage({super.key});

  final List<Map<String, String>> menuList = const [
    {
      "vendor": "Laper’in Cathering",
      "menu": "Nasi Uduk Ayam Bumbu",
      "desc":
          "Nasi uduk kaya rempah dengan sepotong ayam bumbu dengan lalapan yang kaya gizi",
    },
    {
      "vendor": "Anande Cathering",
      "menu": "Ayam Balado",
      "desc":
          "Ayam kampung goreng balado, sayur kangkung,  dan tahu tempe goreng",
    },
    {
      "vendor": "DeLuna Cathering",
      "menu": "Sop Daging Rumput laut",
      "desc":
          "Sop dengan potongan daging sapi yang dimasak kuah kaldu ditambah rumput  laut yang menyegarkan dan sehat",
    },
    {
      "vendor": "OndeMande Cathering",
      "menu": "Ikan Bakar Sambal Matah",
      "desc":
          "Ikan laut yang dibakar dengan rempah khas minang dan dipadukan dengan sambal matah khas bali menghasilkan cita rasa yang mengunggah selera",
    },
    {
      "vendor": "Golden Citty Cathering",
      "menu": "Dadar Geprek Sambal kecap",
      "desc":
          "Telur dadar yang dimasak dengan tepung crispy dan digeprek dilengkapi sambal kecap dengan irisan cabe dan rempah lainnya",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color(0xFF1F186F),
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 36,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.error, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Farastika Allistio',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'Laper’in Cathering',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.home_outlined, color: Colors.white),
                const SizedBox(width: 16),
                const Icon(Icons.menu, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.arrow_back),
                SizedBox(width: 8),
                Text(
                  "Menu Hari Ini",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.tune),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hasil penelusuran untuk "Laper’in Cathering"',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: menuList.length,
                itemBuilder: (context, index) {
                  final item = menuList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['vendor']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['menu']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['desc']!,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
