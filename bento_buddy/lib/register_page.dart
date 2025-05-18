import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? selectedStatus;
  final List<String> statuses = [
    'Admin Sekolah',
    'Admin Catering',
    'Admin Pemerintah',
    'Umum',
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController institutionNameController =
      TextEditingController();
  final TextEditingController institutionAddressController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(
                        255,
                        49,
                        43,
                        43,
                      ), // Judul juga putih
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Status
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  hint: const Text('Status'),
                  items:
                      statuses.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 12),

                // Nama Lengkap
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration(hintText: 'Nama Lengkap'),
                ),
                const SizedBox(height: 12),

                // Nomor Identitas
                TextFormField(
                  controller: idController,
                  decoration: _inputDecoration(hintText: 'Nomor Identitas'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // Nama Instansi
                TextFormField(
                  controller: institutionNameController,
                  decoration: _inputDecoration(hintText: 'Nama Instansi'),
                ),
                const SizedBox(height: 12),

                // Alamat Instansi
                TextFormField(
                  controller: institutionAddressController,
                  decoration: _inputDecoration(hintText: 'Alamat Instansi'),
                ),
                const SizedBox(height: 12),

                // Username
                TextFormField(
                  controller: usernameController,
                  decoration: _inputDecoration(hintText: 'Username'),
                ),
                const SizedBox(height: 12),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(hintText: 'Password'),
                ),
                const SizedBox(height: 20),

                // Tombol Register
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Tambahkan aksi untuk register
                      print('Register ditekan');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white, // Warna teks putih
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text('Register'),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey.shade300,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
