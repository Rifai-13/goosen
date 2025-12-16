import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goosen/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Negative Test: Checkout without Address Validation', (
    WidgetTester tester,
  ) async {
    // --- 1. Setup & Configuration ---
    await Firebase.initializeApp();
    try {
      await dotenv.load(fileName: ".env");
    } catch (_) {}

    const String testEmail = 'arthur13@gmail.com';
    const String testPassword = 'arthur13';

    print('🚀 Starting Negative Test: Checkout Validation');

    // --- 2. Start App & Login ---
    await tester.pumpWidget(const app.MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final btnMasuk = find.text('Masuk');
    if (btnMasuk.evaluate().isNotEmpty) {
      await tester.tap(btnMasuk);
      await tester.pumpAndSettle();
    }

    print('📍 Logging in...');
    await tester.enterText(find.byKey(const Key('email_input')), testEmail);
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('password_input')),
      testPassword,
    );
    await tester.pump();

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle(const Duration(seconds: 8));

    // --- 3. Add Item to Cart ---
    print('📍 Adding Item to Cart...');
    final listViewFinder = find.byType(ListView).last;
    final firstFoodItem = find
        .descendant(of: listViewFinder, matching: find.byType(GestureDetector))
        .first;

    await tester.ensureVisible(firstFoodItem);
    await tester.pumpAndSettle();
    await tester.tap(firstFoodItem);
    await tester.pumpAndSettle();

    final btnTambahFinder = find.text('Tambah');
    if (btnTambahFinder.evaluate().isNotEmpty) {
      await tester.tap(btnTambahFinder.first);
    } else {
      await tester.tap(find.byIcon(Icons.add).first);
    }
    await tester.pumpAndSettle();

    // Navigate to Checkout
    await tester.tap(find.text('Siap diantar...'));
    await tester.pumpAndSettle();

    // --- 4. Negative Scenario: Checkout without Address ---
    print('📍 Attempting checkout with empty address...');

    // Verify current screen is Checkout
    final btnPlaceOrder = find.text('Place delivery order');
    expect(btnPlaceOrder, findsOneWidget);

    // Action: Click Checkout directly (Skip Address Selection)
    await tester.tap(btnPlaceOrder);
    await tester.pumpAndSettle();

    // --- 5. Validation ---
    print('📍 Validating Error Handling...');

    // Assert: SnackBar Error must appear
    expect(
      find.text("Harap pilih alamat pengiriman terlebih dahulu!"),
      findsOneWidget,
    );

    // Assert: Must NOT navigate to Success Screen
    expect(find.text('Congratulation'), findsNothing);

    // Assert: Must remain on Checkout Screen
    expect(btnPlaceOrder, findsOneWidget);

    print('✅ Test Passed: Validation correctly blocked checkout.');
  });
}
