// checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Data statis untuk ditampilkan di checkout
const String restaurantName = "Katsugi Bento by Kopi Bambang";
const String deliveryAddress = "Jalan Raya Dadaprejo No .293";
const int subtotal = 23000;
const int deliveryFee = 13000;
final int total = subtotal + deliveryFee;

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp.',
      decimalDigits: 0,
    ).format(amount);
  }

  // --- WIDGET CONTAINER PEMBUNGKUS DENGAN SHADOW ---
  // Kita buat helper widget agar kodenya tidak berulang dan lebih rapi
  Widget _buildCardWrapper({required Widget child, EdgeInsets? padding}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Sudut membulat
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Bayangan lembut
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // Ubah latar belakang agar card lebih menonjol
      // Bagian bawah (Floating Action Button) - Tetap
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Logika proses order di sini
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E9C3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Place delivery order',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: CustomScrollView(
        slivers: [
          _buildCustomAppBar(context),

          SliverList(
            delegate: SliverChildListDelegate([
              // --- 1. PILIHAN JENIS PENGIRIMAN ---
              // DIBUNGKUS OLEH _buildCardWrapper
              _buildCardWrapper(
                child: Column(
                  children: [
                    _buildDeliveryOption(
                      title: 'Express',
                      duration: '20 min',
                      info: 'Direct to you, guaranteed on time',
                      price: 17000,
                      isSelected: false,
                    ),
                    const Divider(height: 1, color: Colors.black12),
                    _buildDeliveryOption(
                      title: 'Reguler',
                      duration: '25 min - 35 min',
                      info: '',
                      price: 13000,
                      isSelected: true,
                    ),
                  ],
                ),
              ),

              // --- 2. LOKASI PENGIRIMAN ---
              // DIBUNGKUS OLEH _buildCardWrapper
              _buildCardWrapper(
                padding: const EdgeInsets.all(16.0), // Padding diatur di sini
                child: _buildDeliveryLocationContent(context),
              ),

              // --- 3. DAFTAR ITEM YANG DIPESAN ---
              // DIBUNGKUS OLEH _buildCardWrapper
              _buildCardWrapper(
                padding: const EdgeInsets.all(16.0), // Padding diatur di sini
                child: _buildItemSummaryContent(),
              ),

              // --- 4. METODE PEMBAYARAN & RINCIAN HARGA ---
              // DIBUNGKUS OLEH _buildCardWrapper
              _buildCardWrapper(
                // Kita hilangkan padding default (16.0) dan ganti dengan padding vertikal yang lebih sedikit
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: _buildPaymentMethodTile(context),
              ),

              // --- 5. RINCIAN HARGA --- (Card 5)
              _buildCardWrapper(
                // Kita gunakan padding default 16.0 untuk ringkasan harga
                child: _buildPriceSummary(),
                padding: const EdgeInsets.all(
                  16.0,
                ), // Pastikan padding diatur disini
              ),

              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  SliverAppBar _buildCustomAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        restaurantName,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildDeliveryOption({
    required String title,
    required String duration,
    required String info,
    required int price,
    required bool isSelected,
  }) {
    // Konten ini tidak perlu dibungkus card lagi karena sudah dibungkus di build method
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ... (Kode Delivery Option tetap sama)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      duration,
                      style: TextStyle(fontSize: 12, color: Colors.green[700]),
                    ),
                  ),
                ],
              ),
              if (info.isNotEmpty)
                Text(
                  info,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          Row(
            children: [
              Text(
                formatCurrency(price),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? const Color(0xFF1E9C3C) : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Konten Lokasi Pengiriman yang akan dimasukkan ke dalam Card Wrapper
  Widget _buildDeliveryLocationContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          deliveryAddress,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_note, size: 20, color: Colors.white),
              label: const Text(
                'Catatan',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E9C3C),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Colors.white,
              ),
              label: const Text(
                'Change location',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E9C3C),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Konten Ringkasan Item yang akan dimasukkan ke dalam Card Wrapper
  Widget _buildItemSummaryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chicken Katsu Single',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '23.000', // Harga per item
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const Text(
                    'item : 1',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit_note,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Catatan',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E9C3C),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500&q=80",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Item Pembayaran hanya sebagai baris
  Widget _buildPaymentMethodTile(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigasi ke halaman pilihan metode pembayaran
      },
      child: Row(
        children: [
          const Icon(Icons.credit_card_outlined, color: Colors.black54),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Column(
      children: [
        _buildPriceRow('Subtotal', subtotal),
        _buildPriceRow('Delivery', deliveryFee),
        const SizedBox(height: 10),
        _buildPriceRow('Total', total, isTotal: true),
      ],
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool isTotal = false}) {
    // Kode _buildPriceRow tetap sama
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
          Text(
            formatCurrency(amount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
