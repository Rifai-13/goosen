import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goosen/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Feature Test: Add Menu to Cart', (WidgetTester tester) async {
    
    // --- 1. Setup & Configuration ---
    await Firebase.initializeApp();
    try { await dotenv.load(fileName: ".env"); } catch (_) {}

    const String testEmail = 'arthur13@gmail.com'; 
    const String testPassword = 'arthur13';

    print('🚀 Starting Test: Add to Cart');

    // --- 2. Start App & Login Routine ---
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
    
    // Submit Login
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle(const Duration(seconds: 8)); 

    // Validate Home Screen
    expect(find.text('Top Rated'), findsOneWidget);
    print('✅ Login Success: Home Screen Loaded');

    // --- 3. Select Food from Home Screen ---
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

    // --- 4. Add to Cart Logic (Restaurant Screen) ---
    print('📍 Testing Add Button Functionality...');

    // Validate Page
    expect(find.text('Menu Pilihan'), findsOneWidget);

    // Find and Click "Tambah" Button (Initial State)
    final btnTambahFinder = find.text('Tambah');
    final btnTambahPertama = btnTambahFinder.first; 

    await tester.ensureVisible(btnTambahPertama);
    await tester.pumpAndSettle();

    await tester.tap(btnTambahPertama);
    await tester.pumpAndSettle(); 

    // Validate Quantity Update (0 -> 1)
    expect(find.text('1'), findsWidgets); 
    print('✅ Quantity updated to 1');

    // Validate Floating Cart Button
    expect(find.text('Siap diantar...'), findsOneWidget);
    expect(find.text('1 item'), findsOneWidget);

    // Increment Quantity using Icon (+)
    print('📍 Incrementing Quantity...');
    
    final btnPlus = find.byIcon(Icons.add).first;
    await tester.tap(btnPlus);
    await tester.pumpAndSettle();

    // Final Validation (Quantity -> 2)
    expect(find.text('2'), findsWidgets);
    expect(find.text('2 item'), findsOneWidget);
    
    print('🎉 Test Passed: Add Menu to Cart Flow Successful.');
  });
}