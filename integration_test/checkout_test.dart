import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goosen/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E: Full Order Flow -> Success -> Activity Verification', (
    WidgetTester tester,
  ) async {
    // --- 1. Setup & Config ---
    await Firebase.initializeApp();
    try {
      await dotenv.load(fileName: ".env");
    } catch (_) {}

    const String testEmail = 'arthur13@gmail.com';
    const String testPassword = 'arthur13';
    const String addressDummy = 'Jl. Robot Testing No. 99';
    const String uniqueNote = 'Tidak Pedas';

    print('🚀 Starting E2E Test: Checkout Flow');

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

    // --- 3. Select Food & Add to Cart ---
    print('📍 Selecting Food Item...');
    final listViewFinder = find.byType(ListView).last;
    final firstFoodItem = find
        .descendant(of: listViewFinder, matching: find.byType(GestureDetector))
        .first;

    await tester.ensureVisible(firstFoodItem);
    await tester.pumpAndSettle();
    await tester.tap(firstFoodItem);
    await tester.pumpAndSettle();

    // Add Item Logic
    final btnTambahFinder = find.text('Tambah');
    if (btnTambahFinder.evaluate().isNotEmpty) {
      await tester.tap(btnTambahFinder.first);
    } else {
      await tester.tap(find.byIcon(Icons.add).first);
    }
    await tester.pumpAndSettle();

    // Proceed to Checkout
    await tester.tap(find.text('Siap diantar...'));
    await tester.pumpAndSettle();

    // --- 4. Checkout: Set Location ---
    print('📍 Setting Location...');
    final btnLocation = find.byIcon(Icons.location_on_outlined).first;
    await tester.ensureVisible(btnLocation);
    await tester.tap(btnLocation);
    await tester.pumpAndSettle();

    // Add New Address
    await tester.tap(find.text('Tambah location'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), addressDummy);
    await tester.pump();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // Select & Apply Address
    await tester.tap(find.text(addressDummy).first);
    await tester.pump();
    await tester.tap(find.text('Apply Location'));
    await tester.pumpAndSettle();

    // --- 5. Checkout: Set Payment ---
    print('📍 Setting Payment Method...');
    final paymentTile = find.text('Payment Method');
    await tester.ensureVisible(paymentTile);
    await tester.tap(paymentTile);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gopay'));
    await tester.pump();
    await tester.tap(find.text('Applay'));
    await tester.pumpAndSettle();

    // --- 6. Checkout: Add Notes ---
    print('📍 Adding Notes...');

    // A. Delivery Note
    final btnDeliveryNote = find.text('Catatan').first;
    await tester.ensureVisible(btnDeliveryNote);
    await tester.tap(btnDeliveryNote);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Titip di satpam');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // B. Order Note (Specific for Validation)
    final btnFoodNote = find.text('Catatan').last;
    await tester.ensureVisible(btnFoodNote);
    await tester.tap(btnFoodNote);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), uniqueNote);
    await tester.pump();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // --- 7. Place Order ---
    print('📍 Placing Order...');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    final btnPlaceOrder = find.text('Place delivery order');
    await tester.tap(btnPlaceOrder);

    print('⏳ Waiting for Firebase Transaction...');
    await tester.pumpAndSettle(const Duration(seconds: 15));

    // --- 8. Validation: Success & Activity ---
    print('📍 Validating Success Screen...');
    expect(find.text('Congratulation'), findsOneWidget);

    print('📍 Navigating to Activity Screen...');
    final btnActivity = find.text('Activity');
    await tester.tap(btnActivity);

    print('⏳ Loading Activity Data...');
    await tester.pumpAndSettle(const Duration(seconds: 8));

    // Verify Data in Activity List
    expect(find.text('Activity'), findsWidgets);

    final noteFinder = find.textContaining("Note: $uniqueNote");
    if (noteFinder.evaluate().isNotEmpty) {
      await tester.ensureVisible(noteFinder.first);
    }

    expect(noteFinder, findsWidgets);

    print('✅ Test Passed: Order created and verified in Activity list.');
  });
}
