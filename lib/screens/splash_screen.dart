import 'package:flutter/material.dart';
import 'menu_awal_screen.dart'; // Import halaman tujuan

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Durasi tampilnya splash screen
    await Future.delayed(const Duration(seconds: 3)); 

    if (mounted) {
      // Pindah ke MenuAwalScreen dan hapus SplashScreen dari stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuAwalScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- LOGO SEBAGAI GAMBAR ---
            // Pastikan PATH gambar Anda benar
            Image.asset(
              'assets/images/logo.png',
              width: 500, // Atur lebar sesuai kebutuhan
              height: 500, // Atur tinggi sesuai kebutuhan
            ),
          ],
        ),
      ),
    );
  }
}