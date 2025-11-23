import 'package:flutter/material.dart';
// Asumsi ada file login/register screen
// import 'login_screen.dart'; 
// import 'register_screen.dart'; 

class MenuAwalScreen extends StatelessWidget {
  const MenuAwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Spacer untuk menempatkan konten di tengah vertikal
            const Spacer(flex: 2), 

            // --- BAGIAN GAMBAR ---
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                // Gunakan placeholder gambar karena Anda tidak menyediakan aset
                child: Container(
                  width: double.infinity,
                  height: 250,
                    color: const Color(0xFFC8E6C9), // Warna hijau muda untuk background
                    child: Image.asset(
                      'assets/images/home1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            

            const Spacer(flex: 1), 

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
            const Spacer(flex: 1), 

            // --- BAGIAN TOMBOL ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  // Navigasi ke halaman Register
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
            const SizedBox(height: 20),
            
            // Teks Kebijakan Privasi
            const Text(
              'Dengan masuk atau mendaftar, kamu menyetujui\nketentuan layanan dan kebijakan privasi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Spacer(flex: 1), 
          ],
        ),
      ),
    );
  }
}