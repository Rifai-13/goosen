import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:goosen/screens/main_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    // Tambahkan listener untuk mengecek validasi setiap kali teks berubah
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengecek apakah semua field valid
  void _validateFields() {
    final emailValid = EmailValidator.validate(_emailController.text);
    final passwordValid =
        _passwordController.text.length >= 6; // Minimal 6 karakter

    // Tombol aktif jika email valid DAN password valid
    final newStatus = emailValid && passwordValid;

    if (_isButtonActive != newStatus) {
      setState(() {
        _isButtonActive = newStatus;
      });
    }
  }

  // Fungsi saat tombol Login diklik
  void _handleLogin() {
    if (_isButtonActive) {
      // TODO: Logika Login (Cek ke database/API)
      print("Login Berhasil: ${_emailController.text}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan warna tombol berdasarkan status _isButtonActive
    final buttonColor = _isButtonActive ? Colors.green : Colors.grey[300];
    final textColor = _isButtonActive ? Colors.white : Colors.black54;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50),

            // --- FIELD EMAIL ---
            const Text(
              'Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- FIELD PASSWORD ---
            const Text(
              'Password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // --- TOMBOL LOGIN DINAMIS ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isButtonActive ? _handleLogin : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // --- Teks Kebijakan Privasi/Layanan ---
            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  children: [
                    const TextSpan(text: 'Saya menyetujui '),
                    TextSpan(
                      text: 'ketentuan Layanan',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: 'kebijakan Privasi',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' Goosen.'),
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
