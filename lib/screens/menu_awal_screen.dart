import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class MenuAwalScreen extends StatelessWidget {
  const MenuAwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Bungkus dengan GestureDetector untuk menutup keyboard
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // 2. Gunakan Center & SingleChildScrollView agar scrollable & rapi
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- BAGIAN GAMBAR ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      color: const Color(0xFFC8E6C9),
                      child: Image.asset(
                        'assets/images/home1.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Ganti Spacer dengan SizedBox agar aman di dalam ScrollView
                  const SizedBox(height: 30),

                  // --- BAGIAN TEKS SAMBUTAN ---
                  const Text(
                    'Selamat datang di Goosan!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Aplikasi yang buat hidupmu lebih nyaman. Siap bantu Kebutuhanmu, kapan pun, di mana pun',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  // --- BAGIAN TOMBOL ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Belum ada akun? Daftar dulu',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Teks Kebijakan Privasi
                  const Text(
                    'Dengan masuk atau mendaftar, kamu menyetujui\nketentuan layanan dan kebijakan privasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}