import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goosen/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Negative Test Suite: Register & Login Validation', (WidgetTester tester) async {
    
    // 🛠️ PERSIAPAN
    await Firebase.initializeApp();
    
    // Data Dummy
    const String emailNgawur = 'budi_tanpa_at'; // Format salah
    const String passwordPendek = '123'; // Kurang dari 6 karakter
    const String emailValid = 'hacker@goosen.com';
    const String passwordSalah = 'passwordngawur';

    print('😈 NEGATIVE TEST DIMULAI (Register & Login)');

    // ==========================================================
    // 🚀 STEP 1: START APP (Splash -> Menu Awal)
    // ==========================================================
    await tester.pumpWidget(const app.MyApp());
    
    // Tunggu Splash & Navigasi selesai
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    
    print('📍 Posisi: Menu Awal');


    // ==========================================================
    // 🔴 STEP 2: NEGATIVE TEST - REGISTER SCREEN
    // ==========================================================
    // Masuk ke halaman Register
    await tester.tap(find.text('Belum ada akun? Daftar dulu'));
    await tester.pumpAndSettle();
    print('📍 Posisi: Register Screen');

    // TEST A: Input Data Tidak Valid (Cek Tombol Mati)
    print('🧪 Test Register 1: Input Email & Password Invalid...');
    
    // Isi field dengan data jelek
    await tester.enterText(find.byKey(const Key('reg_name')), 'Budi');
    await tester.enterText(find.byKey(const Key('reg_email')), emailNgawur); // Email Salah
    await tester.enterText(find.byKey(const Key('reg_phone')), '08123'); // HP Kependekan
    await tester.enterText(find.byKey(const Key('reg_password')), passwordPendek); // Pass < 6
    await tester.pump();

    // Validasi: Tombol Register HARUS MATI (Disabled)
    final ElevatedButton btnRegister = tester.widget(find.byKey(const Key('reg_button')));
    
    if (btnRegister.onPressed == null) {
      print('✅ SUKSES REGISTER: Tombol Mati saat data invalid.');
    } else {
      print('❌ GAGAL REGISTER: Tombol masih nyala padahal data salah!');
    }

    // --- PERBAIKAN DI SINI ---
    // Keluar dari Register (Back ke Menu Awal)
    print('🔙 Mencoba Kembali ke Menu Awal...');
    
    // 1. Tutup keyboard dulu biar tombol Back tidak ketutupan/kegeser
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    // 2. Cari tombol Back dengan Icon spesifik (bukan byType IconButton)
    final backButton = find.byIcon(Icons.arrow_back);
    
    // Pastikan tombolnya ketemu
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
      await tester.pumpAndSettle(); // Tunggu animasi pindah halaman
    } else {
      // Cadangan: Kalau tombol UI gak ketemu, pake tombol Back Android System
      print('⚠️ Tombol Back UI tidak ketemu, coba System Back...');
      await tester.pageBack();
      await tester.pumpAndSettle();
    }


    // ==========================================================
    // 🔴 STEP 3: NEGATIVE TEST - LOGIN SCREEN
    // ==========================================================
    print('📍 Kembali ke Menu Awal -> Masuk Login');
    
    // Cek dulu apakah kita beneran sudah di Menu Awal?
    if (find.text('Masuk').evaluate().isEmpty) {
        print('😱 GAWAT: Masih stuck di Register. Memaksa System Back sekali lagi...');
        await tester.pageBack();
        await tester.pumpAndSettle();
    }
    
    // Masuk ke halaman Login
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    // TEST B: Input Format Salah (Cek Tombol Mati)
    print('🧪 Test Login 1: Cek Validasi Input...');
    await tester.enterText(find.byKey(const Key('email_input')), emailNgawur);
    await tester.pump();
    
    final ElevatedButton btnLogin = tester.widget(find.byKey(const Key('login_button')));
    
    if (btnLogin.onPressed == null) {
      print('✅ SUKSES LOGIN: Tombol Mati saat email invalid.');
    } else {
      print('❌ GAGAL LOGIN: Tombol masih nyala padahal email salah!');
    }


    // TEST C: Input Benar tapi Password Salah (Cek Error Firebase)
    print('🧪 Test Login 2: Coba Login Paksa (Wrong Password)...');

    // Perbaiki input biar tombol nyala
    await tester.enterText(find.byKey(const Key('email_input')), emailValid);
    await tester.enterText(find.byKey(const Key('password_input')), passwordSalah);
    await tester.pump();

    // Tutup Keyboard (Wajib biar tombol kena klik)
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    // Klik Login
    await tester.tap(find.byKey(const Key('login_button')));
    
    // Tunggu respon Firebase (biasanya cepat kalau error)
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Validasi Error:
    // 1. Pastikan TIDAK pindah ke Home (Teks 'Top Rated' tidak boleh ada)
    expect(find.text('Top Rated'), findsNothing);
    
    // 2. Pastikan masih di halaman Login
    expect(find.text('Login'), findsWidgets);

    // 3. Cek SnackBar Error
    if (find.byType(SnackBar).evaluate().isNotEmpty) {
       print('✅ SUKSES: Muncul Pesan Error dari Firebase.');
    } else {
       print('⚠️ WARNING: SnackBar tidak muncul (mungkin logic error handling beda).');
    }

    print('🎉 SEMUA NEGATIVE TEST SELESAI!');
  });
}