import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  
  // 1. STATE UNTUK PASSWORD VISIBILITY
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateFields() {
    final emailValid = EmailValidator.validate(_emailController.text);
    final passwordValid = _passwordController.text.length >= 6; 

    final newStatus = emailValid && passwordValid;

    if (_isButtonActive != newStatus) {
      setState(() {
        _isButtonActive = newStatus;
      });
    }
  }

  // 2. FUNGSI NOTIFIKASI (SAMA DENGAN REGISTER)
  void _showTopNotification(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle, 
              color: Colors.white
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150, 
          left: 16,
          right: 16,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // 3. FUNGSI LOGIN KE FIREBASE
  Future<void> _handleLogin() async {
    if (_isButtonActive) {
      // Tampilkan Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // EKSEKUSI LOGIN
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Jika berhasil (tidak error), tutup loading
        if (context.mounted) Navigator.pop(context);

        _showTopNotification("Login Berhasil! Selamat Datang.");
        
        // Delay sedikit
        await Future.delayed(const Duration(seconds: 1));

        // Pindah ke Halaman Utama
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        }

      } on FirebaseAuthException catch (e) {
        // Tutup loading jika error
        if (context.mounted) Navigator.pop(context);

        String message = 'Terjadi kesalahan login.';
        
        // Cek error code dari Firebase
        if (e.code == 'user-not-found') {
          message = 'Email tidak terdaftar.';
        } else if (e.code == 'wrong-password') {
          message = 'Password salah.';
        } else if (e.code == 'invalid-credential') {
          // Firebase versi baru sering pakai ini untuk email/pass salah
          message = 'Email atau Password salah.';
        } else if (e.code == 'invalid-email') {
          message = 'Format email salah.';
        }

        // Tampilkan Error Merah di Atas
        _showTopNotification(message, isError: true);
        
      } catch (e) {
        if (context.mounted) Navigator.pop(context);
        _showTopNotification('Error: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            _buildInputField(
              controller: _emailController, 
              hint: 'Email', 
              keyboardType: TextInputType.emailAddress
            ),
            
            const SizedBox(height: 24),

            // --- FIELD PASSWORD (DENGAN MATA) ---
            const Text(
              'Password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInputField(
              controller: _passwordController, 
              hint: 'Password', 
              keyboardType: TextInputType.visiblePassword,
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),

            const SizedBox(height: 40),

            // --- TOMBOL LOGIN ---
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

            // --- FOOTER TEKS ---
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

  // 4. HELPER WIDGET YANG SUDAH DIPERBAIKI POSISI TEXT-NYA
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 55, // Tinggi fix biar rapi
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}