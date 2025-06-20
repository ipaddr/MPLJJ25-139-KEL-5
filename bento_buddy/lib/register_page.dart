import 'package:bento_buddy/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'notif_register.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? selectedStatus;
  bool _obscureText = true;
  final AuthService _authService = AuthService();

  final List<String> statuses = [
    'Admin Sekolah',
    'Admin Catering',
    'Admin Pemerintah',
    'Umum',
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController institutionNameController =
      TextEditingController();
  final TextEditingController institutionAddressController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    nikController.dispose();
    institutionNameController.dispose();
    institutionAddressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon:
          prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
      suffixIcon: suffixIcon,
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }

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
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 16, 4, 68),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  hint: const Text('Status',
                      style: TextStyle(color: Colors.grey)),
                  items: statuses.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  decoration:
                      _inputDecoration(prefixIcon: Icons.person_outline),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration(
                      hintText: 'Nama Lengkap',
                      prefixIcon: Icons.person_outline),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nikController,
                  decoration: _inputDecoration(
                      hintText: 'Nomor Induk Kependudukan (NIK)',
                      prefixIcon: Icons.credit_card),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: _inputDecoration(
                      hintText: 'Nomor HP', prefixIcon: Icons.phone),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                if (selectedStatus != 'Umum' && selectedStatus != null)
                  Column(
                    children: [
                      TextFormField(
                        controller: institutionNameController,
                        decoration: _inputDecoration(
                            hintText: 'Nama Instansi',
                            prefixIcon: Icons.business),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: institutionAddressController,
                        decoration: _inputDecoration(
                            hintText: 'Alamat Instansi',
                            prefixIcon: Icons.location_on_outlined),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                TextFormField(
                  controller: emailController,
                  decoration: _inputDecoration(
                      hintText: 'Email', prefixIcon: Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: _inputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedStatus == null ||
                          nameController.text.isEmpty ||
                          nikController.text.isEmpty ||
                          phoneNumberController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Semua field wajib diisi!')),
                        );
                        return;
                      }

                      if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailController.text.trim())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Format email tidak valid!')),
                        );
                        return;
                      }

                      if (passwordController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Password minimal 6 karakter!')),
                        );
                        return;
                      }

                      if (nikController.text.length != 16 ||
                          !RegExp(r"^[0-9]+").hasMatch(nikController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('NIK harus 16 digit angka!')),
                        );
                        return;
                      }

                      if (!RegExp(r"^[0-9]+")
                          .hasMatch(phoneNumberController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Nomor HP hanya boleh berisi angka!')),
                        );
                        return;
                      }

                      if (phoneNumberController.text.length < 10 ||
                          phoneNumberController.text.length > 13) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Panjang Nomor HP harus antara 10-13 digit!')),
                        );
                        return;
                      }

                      if (!phoneNumberController.text.startsWith('08')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Nomor HP harus dimulai dengan '08'!")),
                        );
                        return;
                      }

                      if (selectedStatus != 'Umum') {
                        if (institutionNameController.text.isEmpty ||
                            institutionAddressController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Nama dan Alamat Instansi wajib diisi!')),
                          );
                          return;
                        }
                      }

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      String? errorMessage =
                          await _authService.registerWithEmailPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        fullName: nameController.text.trim(),
                        nik: nikController.text.trim(),
                        phoneNumber: phoneNumberController.text.trim(),
                        role: selectedStatus!,
                        institutionName: selectedStatus != 'Umum'
                            ? institutionNameController.text.trim()
                            : null,
                        institutionAddress: selectedStatus != 'Umum'
                            ? institutionAddressController.text.trim()
                            : null,
                      );

                      if (!mounted) return;
                      Navigator.of(context).pop();

                      if (errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registrasi berhasil!')),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotifRegisterPage()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Gagal registrasi: $errorMessage')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2378),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child:
                        const Text('Register', style: TextStyle(fontSize: 16)),
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
}
