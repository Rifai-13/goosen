import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'login_screen.dart'; // Import ke halaman login

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    // Tambahkan listener untuk mengecek validasi setiap kali teks berubah
    _nameController.addListener(_validateFields);
    _emailController.addListener(_validateFields);
    _phoneController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengecek apakah semua field valid
  void _validateFields() {
    final nameValid = _nameController.text.isNotEmpty;
    final emailValid = EmailValidator.validate(_emailController.text);
    final phoneValid = _phoneController.text.length >= 8; // Minimal 8 digit
    final passwordValid = _passwordController.text.length >= 6; // Minimal 6 karakter
    
    // Tombol aktif jika SEMUA field valid
    final newStatus = nameValid && emailValid && phoneValid && passwordValid;
    
    if (_isButtonActive != newStatus) {
      setState(() {
        _isButtonActive = newStatus;
      });
    }
  }

  // Fungsi saat tombol Register diklik
  void _handleRegister() {
    if (_isButtonActive) {
      // TODO: Logika pendaftaran user baru (Misalnya Firebase Auth)
      print("Pendaftaran Berhasil: Nama ${_nameController.text}, Email ${_emailController.text}");
      // Navigasi ke halaman Login setelah berhasil daftar
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const LoginScreen())
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
                'Register',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),

            // --- FIELD NAMA ---
            _buildInputField('Nama', 'Nama', _nameController, TextInputType.text),
            const SizedBox(height: 24),

            // --- FIELD EMAIL ---
            _buildInputField('Email', 'Email', _emailController, TextInputType.emailAddress),
            const SizedBox(height: 24),

            // --- FIELD NOMOR TELEPON ---
            _buildInputField('Nomor Telepon', 'No.Telepon', _phoneController, TextInputType.phone),
            const SizedBox(height: 24),

            // --- FIELD PASSWORD ---
            _buildInputField('Password', 'Password', _passwordController, TextInputType.visiblePassword, obscureText: true),
            const SizedBox(height: 40),

            // --- TOMBOL REGISTER DINAMIS ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isButtonActive ? _handleRegister : null, // Hanya aktif jika _isButtonActive true
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.bold),
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
                      style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: 'kebijakan Privasi',
                      style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
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

  // Widget Helper untuk membuat input field
  Widget _buildInputField(
    String label, 
    String hint, 
    TextEditingController controller, 
    TextInputType keyboardType, 
    {bool obscureText = false}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}