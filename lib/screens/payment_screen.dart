import 'package:flutter/material.dart';

// ==========================================
// 1. MODEL DATA
// ==========================================

// Model untuk opsi pembayaran
class PaymentMethod {
  final String title;
  final IconData icon;

  PaymentMethod({required this.title, required this.icon});
}

// Data Dummy Metode Pembayaran
final List<PaymentMethod> paymentOptions = [
  PaymentMethod(title: 'Cash Money', icon: Icons.attach_money),
  PaymentMethod(title: 'Gopay', icon: Icons.phone_android),
  PaymentMethod(title: 'Credit Card', icon: Icons.credit_card),
];

// ==========================================
// 2. PAYMENT SCREEN (STATEFUL)
// ==========================================
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // State untuk melacak pilihan pembayaran yang aktif (default: Cash Money)
  String _selectedMethod = 'Cash Money';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _selectedMethod);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E9C3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Applay',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      // AppBar kustom
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      // Body konten
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: paymentOptions.map((method) {
            return _buildPaymentOption(method);
          }).toList(),
        ),
      ),
    );
  }

  // Widget untuk menampilkan satu opsi pembayaran
  Widget _buildPaymentOption(PaymentMethod method) {
    bool isSelected = _selectedMethod == method.title;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = method.title;
        });
      },
      // Ganti margin di Container menjadi SizedBox antar item
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF1E9C3C) : Colors.black12,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icon harus berwarna hijau solid jika terpilih
              Icon(
                method.icon,
                color: isSelected ? const Color(0xFF1E9C3C) : Colors.green,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  method.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? const Color(0xFF1E9C3C) : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
