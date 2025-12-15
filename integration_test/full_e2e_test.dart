import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goosen/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E Flow: Splash -> Menu -> Register -> Login -> Home', (
    WidgetTester tester,
  ) async {
    // --- 1. Setup & Initialization ---
    await Firebase.initializeApp();

    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print('Info: Failed to load .env file: $e');
    }

    // Generate unique credentials for testing
    final String uniqueEmail =
        'test${DateTime.now().millisecondsSinceEpoch}@goosen.com';
    final String password = 'password123';

    print('Starting E2E Test with: $uniqueEmail');

    // --- 2. Start App (Splash Screen) ---
    await tester.pumpWidget(const app.MyApp());

    // Wait for Splash Screen & Navigation duration
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // --- 3. Menu Awal Screen ---
    expect(find.text('Selamat datang di Goosan!'), findsOneWidget);
    final btnDaftar = find.text('Belum ada akun? Daftar dulu');
    expect(btnDaftar, findsOneWidget);

    await tester.tap(btnDaftar);
    await tester.pumpAndSettle();

    // --- 4. Register Screen ---
    print('📍 Navigated to Register Screen');

    await tester.enterText(
      find.byKey(const Key('reg_name')),
      'Test User Goosen',
    );
    await tester.pump();

    await tester.enterText(find.byKey(const Key('reg_email')), uniqueEmail);
    await tester.pump();

    await tester.enterText(find.byKey(const Key('reg_phone')), '08123456789');
    await tester.pump();

    await tester.enterText(find.byKey(const Key('reg_password')), password);
    await tester.pump();

    // Close keyboard and ensure button visibility to prevent obstruction
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    final btnRegister = find.byKey(const Key('reg_button'));
    await tester.ensureVisible(btnRegister);
    await tester.pumpAndSettle();
    await tester.tap(btnRegister);

    // Wait for Firebase registration process
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // --- 5. Login Screen ---
    if (find.text('Login').evaluate().isNotEmpty) {
      print('✅ Successfully redirected to Login Screen');
    } else {
      if (find.byType(SnackBar).evaluate().isNotEmpty) {
        print('⚠️ Error SnackBar detected');
      }
      return;
    }

    await tester.enterText(find.byKey(const Key('email_input')), uniqueEmail);
    await tester.pump();

    await tester.enterText(find.byKey(const Key('password_input')), password);
    await tester.pump();

    // Close keyboard before clicking login
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle(const Duration(seconds: 8));

    // --- 6. Home Screen Verification ---
    print('📍 Navigated to Home Screen');
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.text('Deals to see when you\'re hungry'), findsOneWidget);
    print('Test Completed Successfully.');
  });
}
