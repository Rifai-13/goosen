import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

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
  bool _isPasswordVisible = false; 

  @override
  void initState() {
    super.initState();
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

  void _validateFields() {
    final nameValid = _nameController.text.isNotEmpty;
    final emailValid = EmailValidator.validate(_emailController.text);
    final phoneValid = _phoneController.text.length >= 8;
    final passwordValid = _passwordController.text.length >= 6;
    
    final newStatus = nameValid && emailValid && phoneValid && passwordValid;
    
    if (_isButtonActive != newStatus) {
      setState(() {
        _isButtonActive = newStatus;
      });
    }
  }

  // --- FUNGSI NOTIFIKASI ---
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

  // --- LOGIC REGISTER FIREBASE ---
  Future<void> _handleRegister() async {
    if (_isButtonActive) {
      // Tutup keyboard sebelum proses dimulai
      FocusScope.of(context).unfocus();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // 1. Buat User di Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String uid = userCredential.user!.uid;

        // 2. Simpan Data Tambahan di Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'customer',
        });

        // 3. Update Display Name di Auth
        await userCredential.user!.updateDisplayName(_nameController.text.trim());

      // --- TAMBAHKAN ANALYTICS DI SINI (SUCCESS) ---
        await FirebaseAnalytics.instance.logSignUp(
          signUpMethod: 'email_password',
        );

        if (context.mounted) Navigator.pop(context);
        _showTopNotification("Registrasi Berhasil! Silakan Login.");

        await Future.delayed(const Duration(seconds: 2));

        if (context.mounted) {
          // Pindah ke Login Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }

      } on FirebaseAuthException catch (e) {
        if (context.mounted) Navigator.pop(context);
        
        // --- OPSIONAL: TRACK REGISTRASI GAGAL ---
        await FirebaseAnalytics.instance.logEvent(
          name: 'sign_up_failed',
          parameters: {
            'error_code': e.code,
            'email': _emailController.text.trim(),
          },
        );
        
        String message = 'Terjadi kesalahan.';
        if (e.code == 'email-already-in-use') {
          message = 'Email ini sudah terdaftar.';
        } else if (e.code == 'weak-password') {
          message = 'Password minimal 6 karakter.';
        }
        
        _showTopNotification(message, isError: true);
        
      } catch (e) {
        if (context.mounted) Navigator.pop(context);
        _showTopNotification('Error: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = _isButtonActive ? const Color(0xFF1E9C3C) : Colors.grey[300];
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
      
      // 👇 PERUBAHAN UTAMA: BUNGKUS DENGAN GESTURE DETECTOR
      body: GestureDetector(
        onTap: () {
          // Logic: Kalau layar disentuh di area kosong, tutup keyboard
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
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
              const SizedBox(height: 20),

              // FIELD NAMA (Pakai Key: reg_name)
              _buildInputField(
                'Nama', 
                'Nama Lengkap', 
                _nameController, 
                TextInputType.name,
                fieldKey: const Key('reg_name'), 
              ),
              const SizedBox(height: 20),

              // FIELD EMAIL (Pakai Key: reg_email)
              _buildInputField(
                'Email', 
                'Email', 
                _emailController, 
                TextInputType.emailAddress,
                fieldKey: const Key('reg_email'),
              ),
              const SizedBox(height: 20),

              // FIELD PHONE (Pakai Key: reg_phone)
              _buildInputField(
                'Nomor Telepon', 
                '08xxxxx', 
                _phoneController, 
                TextInputType.phone,
                fieldKey: const Key('reg_phone'),
              ),
              const SizedBox(height: 20),

              // FIELD PASSWORD (Pakai Key: reg_password)
              _buildInputField(
                'Password', 
                'Password', 
                _passwordController, 
                TextInputType.visiblePassword, 
                fieldKey: const Key('reg_password'),
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
              const SizedBox(height: 30),

              // TOMBOL REGISTER (Pakai Key: reg_button)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  key: const Key('reg_button'), // Key untuk Testing
                  onPressed: _isButtonActive ? _handleRegister : null,
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
              const SizedBox(height: 78),

              // FOOTER TERMS
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
      ),
    );
  }

  // --- HELPER BUILD INPUT FIELD (Updated with Key) ---
  Widget _buildInputField(
    String label, 
    String hint, 
    TextEditingController controller, 
    TextInputType keyboardType, 
    {bool obscureText = false, Widget? suffixIcon, Key? fieldKey}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        
        TextField(
          key: fieldKey, // Key dipasang di sini
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(fontSize: 16, color: Colors.black),
          
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300, 
                width: 1.5
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF1E9C3C),
                width: 2.0, 
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}