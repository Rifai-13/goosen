import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goosen/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E: Login -> Add Menu -> Set Location/Payment -> Place Order', (WidgetTester tester) async {
    
    // --- 1. SETUP & LOGIN ---
    await Firebase.initializeApp();
    try { await dotenv.load(fileName: ".env"); } catch (_) {}

    const String testEmail = 'arthur13@gmail.com'; 
    const String testPassword = 'arthur13';
    const String addressDummy = 'Jl. Robot Testing No. 99';

    print('🚀 STARTING FULL CHECKOUT TEST');

    await tester.pumpWidget(const app.MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Login Routine
    final btnMasuk = find.text('Masuk');
    if (btnMasuk.evaluate().isNotEmpty) {
      await tester.tap(btnMasuk);
      await tester.pumpAndSettle();
    }

    print('📍 Logging in...');
    await tester.enterText(find.byKey(const Key('email_input')), testEmail);
    await tester.pump();
    await tester.enterText(find.byKey(const Key('password_input')), testPassword);
    await tester.pump();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle(const Duration(seconds: 8)); 

    // --- 2. SELECT FOOD & ADD TO CART ---
    print('📍 Selecting Food...');
    final listViewFinder = find.byType(ListView).last;
    final firstFoodItem = find.descendant(of: listViewFinder, matching: find.byType(GestureDetector)).first;
    await tester.ensureVisible(firstFoodItem);
    await tester.pumpAndSettle();
    await tester.tap(firstFoodItem); // To Restaurant Menu
    await tester.pumpAndSettle();

    print('📍 Adding Item to Cart...');
    final btnTambahFinder = find.text('Tambah');
    if (btnTambahFinder.evaluate().isNotEmpty) {
       await tester.tap(btnTambahFinder.first);
    } else {
       await tester.tap(find.byIcon(Icons.add).first);
    }
    await tester.pumpAndSettle();

    // Go to Checkout
    await tester.tap(find.text('Siap diantar...'));
    await tester.pumpAndSettle(); 

    // --- 3. CHECKOUT: SET LOCATION ---
    print('📍 Checkout: Setting Location...');
    
    final btnLocation = find.byIcon(Icons.location_on_outlined).first;
    // ensureVisible dihapus untuk widget bottom/fixed, tapi kalau location ada di body list, boleh dipakai.
    // Asumsi tombol location ada di body scrollable:
    await tester.ensureVisible(btnLocation); 
    await tester.tap(btnLocation);
    await tester.pumpAndSettle(); 

    // Add New Address
    print('👉 Adding New Address...');
    await tester.tap(find.text('Tambah location'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), addressDummy);
    await tester.pump();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // Select & Apply
    print('👉 Selecting & Applying Address...');
    await tester.tap(find.text(addressDummy).first);
    await tester.pump();
    await tester.tap(find.text('Apply Location'));
    await tester.pumpAndSettle(); 

    // Validate Address
    expect(find.text(addressDummy), findsOneWidget);
    print('✅ Location Set Successfully');

    // --- 4. CHECKOUT: SET PAYMENT METHOD ---
    print('📍 Checkout: Setting Payment...');
    
    final paymentTile = find.text('Payment Method');
    await tester.ensureVisible(paymentTile);
    await tester.tap(paymentTile);
    await tester.pumpAndSettle(); 

    await tester.tap(find.text('Gopay'));
    await tester.pump();
    await tester.tap(find.text('Applay')); 
    await tester.pumpAndSettle();

    expect(find.text('Gopay'), findsOneWidget);
    print('✅ Payment Method Set to Gopay');

    // --- 5. CHECKOUT: ADD NOTES (UPDATED FLOW) ---
    print('📍 Checkout: Adding Notes...');

    // Klik tombol 'Catatan' (Pilih yang pertama, biasanya Delivery Note)
    final btnDeliveryNote = find.text('Catatan').first; 
    await tester.ensureVisible(btnDeliveryNote); // Pastikan terlihat
    await tester.tap(btnDeliveryNote);
    await tester.pumpAndSettle();
    
    // 1. Ketik Catatan
    await tester.enterText(find.byType(TextField), 'Pagar Hitam');
    await tester.pump();

    // 2. TUTUP KEYBOARD (Klik area kosong / Unfocus)
    print('👉 Closing Keyboard before Saving...');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(); // Tunggu keyboard turun

    // 3. Klik Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // --- 6. PLACE ORDER (FIXED ERROR) ---
    print('📍 Checkout: Placing Order...');
    
    // Pastikan keyboard benar-benar tertutup sebelum checkout
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    final btnPlaceOrder = find.text('Place delivery order');
    
    // ⚠️ PERBAIKAN: HAPUS ensureVisible KARENA BUTTON ADA DI BOTTOM NAV BAR
    // await tester.ensureVisible(btnPlaceOrder); <--- INI PENYEBAB ERROR TADI
    
    // Langsung tap saja
    await tester.tap(btnPlaceOrder);
    
    // Wait for Firebase Transaction
    print('⏳ Sending Order to Firebase...');
    await tester.pumpAndSettle(const Duration(seconds: 12));

    // --- 7. VALIDASI FINAL ---
    expect(find.text('Place delivery order'), findsNothing);
    
    print('🎉 MISSION COMPLETE: Order Placed Successfully!');
  });
}