import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goosen/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Negative Test: Add & Remove Item Logic', (WidgetTester tester) async {
    
    // --- 1. Setup & Configuration ---
    await Firebase.initializeApp();
    try { await dotenv.load(fileName: ".env"); } catch (_) {}

    const String testEmail = 'arthur13@gmail.com'; 
    const String testPassword = 'arthur13';

    print('🚀 Starting Negative Test: Cart Logic');

    // --- 2. Start App & Login ---
    await tester.pumpWidget(const app.MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Navigate to Login
    final btnMasuk = find.text('Masuk');
    if (btnMasuk.evaluate().isNotEmpty) {
      await tester.tap(btnMasuk);
      await tester.pumpAndSettle();
    }

    // Input Credentials
    print('📍 Logging in...');
    await tester.enterText(find.byKey(const Key('email_input')), testEmail);
    await tester.pump();
    await tester.enterText(find.byKey(const Key('password_input')), testPassword);
    await tester.pump();
    
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle(const Duration(seconds: 8)); 

    // Validate Home
    expect(find.text('Top Rated'), findsOneWidget);
    print('✅ Login Success');

    // --- 3. Navigate to Food Detail ---
    print('📍 Selecting Food Item...');
    final listViewFinder = find.byType(ListView).last;
    final firstFoodItem = find.descendant(
      of: listViewFinder, 
      matching: find.byType(GestureDetector)
    ).first;

    await tester.ensureVisible(firstFoodItem);
    await tester.pumpAndSettle();

    await tester.tap(firstFoodItem);
    await tester.pumpAndSettle(); 

    // --- 4. Negative Scenario: Add then Remove (Undo) ---
    print('📍 Testing Add & Remove Logic...');

    // Step A: Add Item (Qty 0 -> 1)
    final btnTambah = find.text('Tambah').first;
    await tester.ensureVisible(btnTambah);
    await tester.pumpAndSettle();
    
    await tester.tap(btnTambah);
    await tester.pumpAndSettle();

    // Assert: Cart appears
    expect(find.text('Siap diantar...'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    print('✅ Item added (Qty: 1)');

    // Step B: Remove Item (Qty 1 -> 0)
    print('👉 Clicking Remove (-) Button...');
    final btnMinus = find.byIcon(Icons.remove).first;
    await tester.tap(btnMinus);
    await tester.pumpAndSettle();

    // Assert: UI Resets to "Tambah"
    expect(find.text('Tambah'), findsWidgets); 
    
    // Assert: Cart Button should disappear/hide (Logic: "1 item" text is gone)
    expect(find.text('1 item'), findsNothing);
    
    print('🎉 Negative Test Passed: Item removed & Cart hidden successfully.');
  });
}