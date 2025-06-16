import 'package:bento_buddy/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'notif_register.dart'; // Import NotifRegisterPage untuk navigasi setelah register
import 'login_page.dart'; // Import LoginPage untuk navigasi kembali ke halaman login

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? selectedStatus;
  bool _obscureText = true;
  final AuthService _authService = AuthService(); // Instance dari AuthService

  final List<String> statuses = [
    'Admin Sekolah',
    'Admin Catering',
    'Admin Pemerintah',
    'Umum',
  ];

  // Controllers untuk setiap TextFormField
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController =
      TextEditingController(); // Mengganti idController menjadi nikController
  final TextEditingController institutionNameController =
      TextEditingController();
  final TextEditingController institutionAddressController =
      TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // Mengganti usernameController menjadi emailController
  final TextEditingController passwordController = TextEditingController();

  // Pastikan untuk membuang controller saat widget dihapus untuk mencegah memory leaks
  @override
  void dispose() {
    nameController.dispose();
    nikController.dispose(); // Dispose nikController
    institutionNameController.dispose();
    institutionAddressController.dispose();
    emailController.dispose(); // Dispose emailController
    passwordController.dispose();
    super.dispose();
  }

  // Helper method untuk konsistensi gaya InputDecoration pada TextFormField
  InputDecoration _inputDecoration({
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText, // Placeholder text
      filled: true, // Fills the background of the TextField
      fillColor: Colors.grey.shade200, // Background color of the TextField
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ), // Content padding
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ), // Rounded corners for the border
        borderSide: BorderSide.none, // Removes the border line
      ),
      prefixIcon:
          prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey)
              : null, // Icon at the start of the input
      suffixIcon:
          suffixIcon, // Icon at the end of the input (used for password toggle)
      hintStyle: const TextStyle(color: Colors.grey), // Style for hint text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the page background with an image
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ), // Horizontal padding for content
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background.png',
            ), // Ensure this asset exists
            fit: BoxFit.cover, // Image covers the entire area
          ),
        ),
        child: SafeArea(
          // Ensures content does not overlap with the status bar or notch
          child: SingleChildScrollView(
            // Allows the page to be scrolled if content exceeds screen height
            child: Column(
              children: [
                const SizedBox(height: 40), // Space at the top
                // Back button (left arrow icon) - Already exists and works
                Align(
                  alignment: Alignment.centerLeft, // Align icon to the left
                  child: GestureDetector(
                    onTap: () {
                      // Navigate back to LoginPage.
                      // pushAndRemoveUntil is used to remove all previous routes
                      // so the user cannot go back to register_page after login.
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (Route<dynamic> route) =>
                            false, // Remove all routes from the stack
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back_ios, // Left arrow icon
                      color:
                          Colors
                              .white, // Icon color to be visible on the background
                      size: 28, // Icon size
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space after back button
                // Page title "REGISTER"
                const Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 28, // Font size
                      fontWeight: FontWeight.bold, // Bold text style
                      decoration: TextDecoration.underline, // Underline
                      color: Color.fromARGB(
                        255,
                        16,
                        4,
                        68,
                      ), // Text color (dark blue, contrasting with white)
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space after title
                // Input Field: Status (Dropdown)
                DropdownButtonFormField<String>(
                  value: selectedStatus, // Selected value
                  hint: const Text(
                    'Status',
                    style: TextStyle(color: Colors.grey),
                  ), // Hint text
                  items:
                      statuses.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value; // Update state when value changes
                    });
                  },
                  decoration: _inputDecoration(
                    prefixIcon: Icons.person_outline,
                  ), // Use helper Decoration
                ),
                const SizedBox(height: 12),

                // Input Field: Nama Lengkap
                TextFormField(
                  controller: nameController, // Controller to get input
                  decoration: _inputDecoration(
                    hintText: 'Nama Lengkap',
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 12),

                // Input Field: Nomor Induk Kependudukan (NIK)
                TextFormField(
                  controller: nikController, // Use nikController
                  decoration: _inputDecoration(
                    hintText:
                        'Nomor Induk Kependudukan (NIK)', // Hint text changed
                    prefixIcon: Icons.credit_card,
                  ),
                  keyboardType:
                      TextInputType.number, // Set keyboard to numbers only
                ),
                const SizedBox(height: 12),

                // Input Field: Nama Instansi (Only visible if status is not 'Umum')
                if (selectedStatus != 'Umum' && selectedStatus != null)
                  Column(
                    children: [
                      TextFormField(
                        controller: institutionNameController,
                        decoration: _inputDecoration(
                          hintText: 'Nama Instansi',
                          prefixIcon: Icons.business,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Input Field: Alamat Instansi (Only visible if status is not 'Umum')
                if (selectedStatus != 'Umum' && selectedStatus != null)
                  Column(
                    children: [
                      TextFormField(
                        controller: institutionAddressController,
                        decoration: _inputDecoration(
                          hintText: 'Alamat Instansi',
                          prefixIcon: Icons.location_on_outlined,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Input Field: Email
                TextFormField(
                  controller: emailController, // Use emailController
                  decoration: _inputDecoration(
                    hintText: 'Email', // Hint text changed
                    prefixIcon: Icons.email_outlined, // Icon changed
                  ),
                  keyboardType:
                      TextInputType.emailAddress, // Set keyboard for email
                ),
                const SizedBox(height: 12),

                // Input Field: Password
                TextFormField(
                  controller: passwordController,
                  obscureText:
                      _obscureText, // Use state for password visibility
                  decoration: _inputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off
                            : Icons
                                .visibility, // Icon changes (eye closed/open)
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText =
                              !_obscureText; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Register Button
                Align(
                  alignment: Alignment.centerRight, // Align button to the right
                  child: ElevatedButton(
                    onPressed: () async {
                      // Make onPressed async
                      // Basic input validation
                      if (selectedStatus == null ||
                          nameController.text.isEmpty ||
                          nikController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Semua field wajib diisi!'),
                          ),
                        );
                        return;
                      }

                      // Additional validation for institution if not 'Umum'
                      if (selectedStatus != 'Umum' &&
                          (institutionNameController.text.isEmpty ||
                              institutionAddressController.text.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Nama dan Alamat Instansi wajib diisi!',
                            ),
                          ),
                        );
                        return;
                      }

                      // Show loading spinner
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                      );

                      // Call the register function from AuthService
                      String?
                      errorMessage = await _authService.registerWithEmailPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        fullName: nameController.text.trim(),
                        nik: nikController.text.trim(),
                        role:
                            selectedStatus!, // selectedStatus cannot be null due to validation above
                        institutionName:
                            selectedStatus != 'Umum'
                                ? institutionNameController.text.trim()
                                : null,
                        institutionAddress:
                            selectedStatus != 'Umum'
                                ? institutionAddressController.text.trim()
                                : null,
                      );

                      // Hide loading spinner
                      Navigator.of(context).pop();

                      if (errorMessage == null) {
                        // Registration successful
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registrasi berhasil!')),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotifRegisterPage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        // Registration failed, show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal registrasi: $errorMessage'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF1E2378,
                      ), // Button background color
                      foregroundColor: Colors.white, // Button text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Rounded corners for the button
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    ), // Button text
                  ),
                ),
                const SizedBox(height: 40), // Space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
