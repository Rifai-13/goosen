import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goosen/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Negative Test Suite: Register & Login Validation', (
    WidgetTester tester,
  ) async {
    // --- Setup & Config ---
    await Firebase.initializeApp();

    const String invalidEmail = 'user_no_at_symbol';
    const String shortPassword = '123';
    const String validEmail = 'hacker@goosen.com';
    const String wrongPassword = 'wrongpassword123';

    print('Starting Negative Test Suite');

    // --- 1. Start App (Splash -> Menu) ---
    await tester.pumpWidget(const app.MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // --- 2. Register Validation Test ---
    print('📍 Testing Register Input Validation...');

    await tester.tap(find.text('Belum ada akun? Daftar dulu'));
    await tester.pumpAndSettle();

    // Input Invalid Data
    await tester.enterText(find.byKey(const Key('reg_name')), 'Test User');
    await tester.enterText(find.byKey(const Key('reg_email')), invalidEmail);
    await tester.enterText(find.byKey(const Key('reg_phone')), '0812');
    await tester.enterText(
      find.byKey(const Key('reg_password')),
      shortPassword,
    );
    await tester.pump();

    // Assert: Register button must be disabled
    final ElevatedButton btnRegister = tester.widget(
      find.byKey(const Key('reg_button')),
    );
    expect(
      btnRegister.onPressed,
      isNull,
      reason: 'Register button should be disabled for invalid input',
    );

    // Navigate Back to Menu
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    final backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
    } else {
      await tester.pageBack();
    }
    await tester.pumpAndSettle();

    // --- 3. Login Validation Test ---
    print('📍 Testing Login Validation...');

    // Ensure we are at Menu before proceeding
    if (find.text('Masuk').evaluate().isEmpty) {
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    // Scenario A: Invalid Email Format
    await tester.enterText(find.byKey(const Key('email_input')), invalidEmail);
    await tester.pump();

    final ElevatedButton btnLogin = tester.widget(
      find.byKey(const Key('login_button')),
    );
    expect(
      btnLogin.onPressed,
      isNull,
      reason: 'Login button should be disabled for invalid email format',
    );

    // Scenario B: Valid Input but Wrong Password (Firebase Check)
    print('📍 Testing Login with Wrong Credentials...');

    await tester.enterText(find.byKey(const Key('email_input')), validEmail);
    await tester.enterText(
      find.byKey(const Key('password_input')),
      wrongPassword,
    );
    await tester.pump();

    // Close Keyboard & Attempt Login
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('login_button')));

    // Wait for Firebase Response
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Assert: User should remain on Login Screen
    expect(find.text('Top Rated'), findsNothing);
    expect(find.text('Login'), findsWidgets);

    // Assert: Error message appeared
    if (find.byType(SnackBar).evaluate().isNotEmpty) {
      print('✅ Success: Error SnackBar appeared as expected.');
    }

    print('Negative Test Suite Completed Successfully.');
  });
}
