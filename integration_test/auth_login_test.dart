import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart'; // Wajib import ini
import 'package:goosen/main.dart' as app; 

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E Login Flow Stable', (WidgetTester tester) async {
    
    // -------------------------------------------------------------
    // 🛠️ LANGKAH 1: INISIALISASI MANUAL (JURUS ANTI CRASH)
    // -------------------------------------------------------------
    // Daripada panggil app.main(), kita siapkan Firebase sendiri
    await Firebase.initializeApp();
    
    // Kita panggil Widget Utama (MyApp) langsung ke dalam Tester
    // Pastikan nama class di main.dart kamu adalah 'MyApp'
    // Kalau namanya lain (misal 'GoosenApp'), ganti 'app.MyApp()' di bawah ini
    await tester.pumpWidget(const app.MyApp()); 
    
    print('🚀 Aplikasi Berhasil Dimulai (Bypass main())...');


    // -------------------------------------------------------------
    // 🕐 LANGKAH 2: TUNGGU SPLASH SCREEN (MANUAL TIME TRAVEL)
    // -------------------------------------------------------------
    // Saat ini layar menampilkan Splash. Kita majukan waktu.
    
    // Maju 3 detik (Sesuai durasi splash kamu)
    await tester.pump(const Duration(seconds: 3));
    
    // Tambah 2 detik lagi biar animasi navigasi ke MenuAwal beres
    await tester.pump(const Duration(seconds: 2));
    
    // Pastikan semua animasi diam
    await tester.pumpAndSettle();


    // -------------------------------------------------------------
    // 🟢 LANGKAH 3: CEK MENU AWAL
    // -------------------------------------------------------------
    // Debugging: Print apa yang tampil di layar
    final texts = find.byType(Text);
    if (tester.widgetList(texts).isEmpty) {
       print('😱 LAYAR MASIH KOSONG. Cek apakah ada error di console?');
    } else {
       // Kalau ini muncul, berarti aplikasi TIDAK CRASH!
       print('✅ MENU AWAL TAMPIL! Teks yang ditemukan:');
       tester.widgetList(texts).forEach((w) => print('   -> "${(w as Text).data}"'));
    }

    // Validasi Menu Awal
    expect(find.text('Selamat datang di Goosan!'), findsOneWidget);
    print('✅ Validasi Menu Awal Sukses');


    // -------------------------------------------------------------
    // 🟡 LANGKAH 4: PINDAH KE LOGIN
    // -------------------------------------------------------------
    final btnMasuk = find.text('Masuk');
    await tester.tap(btnMasuk);
    await tester.pumpAndSettle();

    // --- PERBAIKAN DI SINI ---
    // Karena ada 2 tulisan "Login" (Judul & Tombol), kita pakai findsWidgets (jamak)
    expect(find.text('Login'), findsWidgets); 
    print('✅ Masuk ke Login Screen');


    // -------------------------------------------------------------
    // 🔵 LANGKAH 5: INPUT FORM
    // -------------------------------------------------------------
    // Pastikan di file LoginScreen.dart kamu SUDAH PAKAI KEY:
    // 1. TextField Email -> key: Key('email_input')
    // 2. TextField Pass  -> key: Key('password_input')
    // 3. Button Login    -> key: Key('login_button')

    final emailField = find.byKey(const Key('email_input'));
    final passwordField = find.byKey(const Key('password_input'));
    final loginButton = find.byKey(const Key('login_button'));

    // Input Email
    print('✍️ Mengisi Email...');
    await tester.enterText(emailField, 'arthur13@gmail.com');
    await tester.pump();

    // Input Password
    print('✍️ Mengisi Password...');
    await tester.enterText(passwordField, 'arhtur13');
    await tester.pump();

    // Klik Login
    print('👉 Klik Tombol Login...');
    await tester.tap(loginButton);
    
    // Tunggu Loading + Pindah Halaman
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Validasi Akhir: Cek apakah tombol login SUDAH HILANG
    expect(loginButton, findsNothing);
    print('🎉 TEST SELESAI & SUKSES! User berhasil Login.');
  });
}
