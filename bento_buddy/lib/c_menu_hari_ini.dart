import 'package:flutter/material.dart';
import 'menu.dart'; // Import halaman menu untuk navigasi ke sana
import 'c_upload_menu.dart'; // Asumsikan ada file ini untuk halaman upload menu

// Asumsi model CateringMenu sudah ada atau didefinisikan di sini
class CateringMenu {
  final String cateringName;
  final String menuName;
  final String description;
  final String imagePath; // Path ke aset gambar menu

  const CateringMenu({
    required this.cateringName,
    required this.menuName,
    required this.description,
    required this.imagePath,
  });
}

class CMenuHariIni extends StatefulWidget {
  const CMenuHariIni({super.key});

  @override
  State<CMenuHariIni> createState() => _MenuHariIniState();
}

class _MenuHariIniState extends State<CMenuHariIni> {
  final TextEditingController _searchController = TextEditingController();
  List<CateringMenu> semuaMenu = [];
  List<CateringMenu> hasilPencarianMenu = [];

  @override
  void initState() {
    super.initState();
    // Data dummy untuk menu hari ini, sesuai gambar
    semuaMenu = const [
      CateringMenu(
        cateringName: 'Laper\'in Cathering',
        menuName: 'Nasi Uduk Ayam Bumbu',
        description:
            'Nasi uduk kaya rempah dengan toping ayam bumbu dengan taburan yang kaya gizi',
        imagePath: 'assets/menu_laperin.png', // [Image of Nasi Uduk Ayam Bumbu]
      ),
      CateringMenu(
        cateringName: 'Anande Cathering',
        menuName: 'Ayam Balado',
        description:
            'Ayam kampung goreng balado, sayur kangkung, dan tahu tempe goreng',
        imagePath: 'assets/menu_anande.png', // [Image of Ayam Balado]
      ),
      CateringMenu(
        cateringName: 'Anande Cathering', // Tambahan menu untuk Anande
        menuName: 'Senghong tahu goreng',
        description: 'Variasi tahu goreng dengan bumbu khas',
        imagePath: 'assets/menu_anande2.png', // Ganti dengan aset yang sesuai
      ),
      CateringMenu(
        cateringName: 'DeLuna Cathering',
        menuName: 'Sop Daging Rumput laut',
        description:
            'Sop dengan potongan daging sapi yang empuk dan rumput laut yang menyegarkan dan sehat',
        imagePath:
            'assets/menu_deluna.png', // [Image of Sop Daging Rumput Laut]
      ),
      CateringMenu(
        cateringName: 'OndeMande Cathering',
        menuName: 'Ikan Bakar Sambal Matah',
        description:
            'Ikan laut panggang dengan rempah khas minang dipadukan dengan sambal matah, menghasilkan cita rasa yang menggugah selera',
        imagePath:
            'assets/menu_ondemande.png', // [Image of Ikan Bakar Sambal Matah]
      ),
      CateringMenu(
        cateringName: 'OndeMande Cathering', // Tambahan menu untuk OndeMande
        menuName: 'Kangkungan rempah khas minang',
        description:
            'Kangkungan rempah khas minang dipadukan dengan sarba ratah',
        imagePath:
            'assets/menu_ondemande2.png', // Ganti dengan aset yang sesuai
      ),
      CateringMenu(
        cateringName: 'Golden City Cathering',
        menuName: 'Dadar Geprek Sambal kecap',
        description:
            'Telur dadar yang dimasak dengan tepung bumbu, disajikan dengan sambal kecap dengan irisan cabe dan rempah rahasia',
        imagePath:
            'assets/menu_goldencity.png', // [Image of Dadar Geprek Sambal Kecap]
      ),
    ];
    hasilPencarianMenu = semuaMenu;
    _searchController.addListener(_filterMenu);
  }

  void _filterMenu() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      hasilPencarianMenu =
          semuaMenu
              .where(
                (menu) =>
                    menu.menuName.toLowerCase().contains(query) ||
                    menu.cateringName.toLowerCase().contains(query) ||
                    menu.description.toLowerCase().contains(query),
              )
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
      backgroundColor: Colors.grey[100], // Warna latar belakang keseluruhan
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          100.0,
        ), // Tinggi AppBar yang disesuaikan
        child: AppBar(
          automaticallyImplyLeading:
              false, // Hapus tombol back default dari AppBar
          backgroundColor: const Color(
            0xFF271A5A,
          ), // Warna AppBar sesuai gambar
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo aplikasi dan info user
                      Row(
                        children: [
                          Image.asset(
                            'assets/logo.png', // [Image of Logo Aplikasi]
                            height: 50,
                            width: 50,
                            errorBuilder:
                                (context, error, stackTrace) => const Icon(
                                  Icons.restaurant,
                                  color: Colors.white,
                                  size: 50,
                                ), // Fallback
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Farastika Allistio', // [Image of Farastika Allistio]
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Laper\'in Cathering', // [Image of Laper'in Cathering]
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Ikon menu
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ), // [Image of Menu Icon]
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Menu(),
                            ), // Navigasi ke halaman Menu
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10), // Spasi di bawah info user
                // Baris kedua AppBar: Tombol kembali, judul "Menu Hari Ini", dan "Upload Menu"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          ); // Kembali ke halaman sebelumnya
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ), // [Image of Back Arrow]
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Menu Hari Ini', // [Image of Menu Hari Ini Title]
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Bagian "Upload Menu"
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman upload menu
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UploadMenuPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Upload Menu', // [Image of Upload Menu]
                          style: TextStyle(
                            color:
                                Colors
                                    .blueAccent, // Warna biru seperti di gambar
                            fontSize: 14,
                            fontWeight: FontWeight.w600, // Sedikit lebih tebal
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            _buildSearchBar(), // [Image of Search Bar]
            const SizedBox(height: 16),
            // Daftar menu per katering
            Expanded(
              child: ListView.builder(
                itemCount: _getCateringNames(hasilPencarianMenu).length,
                itemBuilder: (context, index) {
                  final cateringName =
                      _getCateringNames(hasilPencarianMenu)[index];
                  final menusForCatering =
                      hasilPencarianMenu
                          .where((menu) => menu.cateringName == cateringName)
                          .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          cateringName, // Nama Katering [Image of Catering Name]
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(
                              0xFF271A5A,
                            ), // Warna teks judul katering
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // Menonaktifkan scroll ListView internal
                        itemCount: menusForCatering.length,
                        itemBuilder: (context, subIndex) {
                          final menu = menusForCatering[subIndex];
                          return MenuItemCard(menu: menu);
                        },
                      ),
                      const SizedBox(height: 20), // Spasi antar katering
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membangun search bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Warna background search bar
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
          ), // [Image of Search Icon]
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari menu...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.grey,
            ), // [Image of Filter Icon]
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter icon pressed!')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper untuk mendapatkan daftar nama katering unik
  List<String> _getCateringNames(List<CateringMenu> menus) {
    return menus.map((m) => m.cateringName).toSet().toList();
  }
}

// Widget untuk menampilkan setiap item menu dalam Card
class MenuItemCard extends StatelessWidget {
  final CateringMenu menu;

  const MenuItemCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ), // Margin bawah untuk setiap card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ), // Sudut membulat
      elevation: 1, // Sedikit bayangan
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Penataan item ke atas
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // Sudut gambar membulat
              child: Image.asset(
                menu.imagePath, // [Image of Menu Item Image]
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons
                        .broken_image, // Fallback icon jika gambar tidak ditemukan
                    size: 80,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const SizedBox(width: 15), // Spasi horizontal
            Expanded(
              // Penting: Expanded agar teks tidak overflow
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Penataan kolom ke kiri
                children: [
                  Text(
                    menu.menuName, // Nama Menu [Image of Menu Name]
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    menu.description, // Deskripsi Menu [Image of Menu Description]
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 3, // Batasi jumlah baris deskripsi
                    overflow:
                        TextOverflow
                            .ellipsis, // Tambahkan "..." jika terlalu panjang
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
