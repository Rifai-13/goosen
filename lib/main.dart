import 'package:flutter/material.dart';
// import 'package:goosen/screens/main_screen.dart';
import './screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//


void main() async {
  // 3. Pastikan binding initialized sebelum panggil kode native/async
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Inisialisasi Firebase dengan opsi dari platform saat ini
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goosen App',
      
      // Tema aplikasi
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), // Ganti jadi hijau biar sesuai tema Goosen
        useMaterial3: true,
        // Ganti font default kalau mau, misal GoogleFonts.poppins()
      ),
      
      // Hilangkan banner debug di pojok kanan atas
      debugShowCheckedModeBanner: false,
      
      // Halaman pertama yang dibuka
      home: const SplashScreen(),
    );
  }
}