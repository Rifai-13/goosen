import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Asumsikan file-file screen ini ada di folder yang benar
import 'location_screen.dart'; 
import 'payment_screen.dart';
import 'order_success_screen.dart';
import 'note_pesanan_screen.dart'; 
import 'note_delivery_screen.dart';

// ==========================================
// 1. MODEL DATA
// ==========================================

// Model untuk Pilihan Pengiriman
class DeliveryOption {
  final String title;
  final String duration;
  final String info;
  final int price;

  DeliveryOption({
    required this.title,
    required this.duration,
    required this.info,
    required this.price,
  });
}

// Data Pilihan Pengiriman (Statis)
final List<DeliveryOption> deliveryOptions = [
  DeliveryOption(
    title: 'Express',
    duration: '20 min',
    info: 'Direct to you, guaranteed on time',
    price: 17000,
  ),
  DeliveryOption(
    title: 'Reguler',
    duration: '25 min - 35 min',
    info: '',
    price: 13000,
  ),
];

// Data statis lain
const String restaurantName = "Katsugi Bento by Kopi Bambang";
const String deliveryAddress = "Jalan Raya Dadaprejo No .293";
const int staticPriceItem = 23000;


// ==========================================
// 2. CHECKOUT SCREEN (STATEFUL)
// ==========================================
class CheckoutScreen extends StatefulWidget {
  final int initialSubtotal; 

  const CheckoutScreen({super.key, required this.initialSubtotal});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Index dari pilihan delivery yang sedang aktif (Default: Reguler index 1)
  int _selectedDeliveryIndex = 1; 
  
  // State untuk menyimpan pilihan pembayaran yang aktif
  String _currentPaymentMethod = 'Cash Money'; 
  
  // State untuk menyimpan catatan item menu
  String _itemNote = '';
  // State untuk menyimpan catatan pengiriman
  String _deliveryNote = ''; 

  // Data mapping untuk Ikon pembayaran
  final Map<String, IconData> _paymentIcons = {
    'Cash Money': Icons.money,
    'Gopay': Icons.phone_android,
    'Credit Card': Icons.credit_card,
  };
  
  // Variabel untuk menyimpan harga berdasarkan state
  late int _subtotal;
  late int _deliveryFee;
  late int _total;

  @override
  void initState() {
    super.initState();
    _subtotal = widget.initialSubtotal;
    _calculatePrices(deliveryOptions[_selectedDeliveryIndex].price);
  }

  // Helper untuk format mata uang
  String formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp.', decimalDigits: 0).format(amount);
  }
  
  // FUNGSI UNTUK MENGHITUNG HARGA AWAL (TANPA setState)
  void _calculatePrices(int newDeliveryFee) {
    _deliveryFee = newDeliveryFee;
    _total = _subtotal + _deliveryFee;
  }

  // FUNGSI UNTUK MENGHITUNG HARGA SETELAH STATE BERUBAH (DIPANGGIL DI setState)
  void _updatePricesState(int newDeliveryFee) {
    _deliveryFee = newDeliveryFee;
    _total = _subtotal + _deliveryFee;
  }

  void _selectDelivery(int index) {
    setState(() {
      _selectedDeliveryIndex = index;
      _updatePricesState(deliveryOptions[index].price);
    });
  }
  
  // --- WIDGET CONTAINER PEMBUNGKUS DENGAN SHADOW ---
  Widget _buildCardWrapper({required Widget child, EdgeInsets? padding}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
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
        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
    );
  }

  Widget _buildDeliveryOption(int index, DeliveryOption option) {
    bool isSelected = _selectedDeliveryIndex == index;

    return InkWell( 
      onTap: () => _selectDelivery(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expanded pada Column ini memperbaiki isu overflow di layar kecil
            Expanded( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible( // Flexible memastikan Text menyesuaikan diri
                        child: Text(
                          option.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          option.duration,
                          style: TextStyle(fontSize: 12, color: Colors.green[700]),
                        ),
                      ),
                    ],
                  ),
                  if (option.info.isNotEmpty)
                    Text(
                      option.info,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  formatCurrency(option.price),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? const Color(0xFF1E9C3C) : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryLocationContent(BuildContext context) {
    final String noteButtonLabel = _deliveryNote.isNotEmpty ? 'edit catatan' : 'Catatan';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery location',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        const Text(
          deliveryAddress,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // TOMBOL CATATAN PENGIRIMAN
            ElevatedButton.icon(
              onPressed: () async {
                final newNote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDeliveryScreen(initialNote: _deliveryNote),
                  ),
                );

                if (newNote != null && newNote is String) {
                  setState(() {
                    _deliveryNote = newNote;
                  });
                }
              },
              icon: Icon(
                _deliveryNote.isNotEmpty ? Icons.edit_note : Icons.edit_note, 
                size: 20, 
                color: Colors.white
              ), 
              label: Text(
                noteButtonLabel,
                style: const TextStyle(color: Colors.white)
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E9C3C),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 12),
            // Tombol Change Location
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.location_on_outlined, size: 20, color: Colors.white),
              label: const Text('Change location', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E9C3C),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        
        // MENAMPILKAN CATATAN PENGIRIMAN
        if (_deliveryNote.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _deliveryNote,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildItemSummaryContent() {
    final String itemNoteButtonLabel = _itemNote.isNotEmpty ? 'edit catatan' : 'Catatan';

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
                  Text(
                    formatCurrency(staticPriceItem),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const Text(
                    'item : 1',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),

                  // TOMBOL CATATAN MENU ITEM
                  ElevatedButton.icon(
                    onPressed: () async {
                      final newNote = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotePesananScreen(initialNote: _itemNote),
                        ),
                      );

                      if (newNote != null && newNote is String) {
                        setState(() {
                          _itemNote = newNote;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit_note, size: 20, color: Colors.white),
                    label: Text(
                      itemNoteButtonLabel,
                      style: const TextStyle(color: Colors.white),
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
        
        // MENAMPILKAN CATATAN MENU ITEM
        if (_itemNote.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _itemNote,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentMethodTile(BuildContext context) {
    IconData currentIcon = _paymentIcons[_currentPaymentMethod] ?? Icons.credit_card_outlined;

    return InkWell(
      onTap: () async {
        final selectedMethod = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentScreen()),
        );

        if (selectedMethod != null && selectedMethod is String) {
          setState(() {
            _currentPaymentMethod = selectedMethod;
          });
        }
      },
      child: Row(
        children: [
          Icon(currentIcon, color: Colors.green),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

          Text(
            _currentPaymentMethod,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Column(
      children: [
        _buildPriceRow('Subtotal', _subtotal),
        _buildPriceRow('Delivery', _deliveryFee),
        const SizedBox(height: 10),
        _buildPriceRow('Total', _total, isTotal: true),
      ],
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool isTotal = false}) {
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

// ==========================================
// 3. WIDGET BUILD UTAMA
// ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      
      // BOTTOM NAVIGATION BAR (Button Place Order)
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderSuccessScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E9C3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Place delivery order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
      
      // BODY (CustomScrollView)
      body: CustomScrollView(
        // ClampingScrollPhysics memperbaiki scroll yang tidak perlu di bawah
        physics: const ClampingScrollPhysics(), 

        slivers: [
          // 1. APP BAR
          _buildCustomAppBar(context),

          // 2. DAFTAR KARTU (SLIVER LIST)
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // CARD 1: Pilihan Pengiriman
                _buildCardWrapper(
                  child: Column(
                    children: deliveryOptions.asMap().entries.map((entry) {
                      int index = entry.key;
                      DeliveryOption option = entry.value;
                      return Column(
                        children: [
                          _buildDeliveryOption(index, option),
                          if (index < deliveryOptions.length - 1)
                            const Divider(height: 1, color: Colors.black12),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                // CARD 2: Lokasi Pengiriman + Delivery Notes
                _buildCardWrapper(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildDeliveryLocationContent(context),
                ),
                
                // CARD 3: Item Summary + Item Notes
                _buildCardWrapper(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildItemSummaryContent(),
                ),
                
                // CARD 4: Payment Method
                _buildCardWrapper(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), 
                  child: _buildPaymentMethodTile(context),
                ),
                
                // CARD 5: Price Summary
                _buildCardWrapper(
                  child: _buildPriceSummary(),
                  padding: const EdgeInsets.all(16.0),
                ),
              ],
            ),
          ),
          
          // 3. SPACER UNTUK BOTTOM NAVIGATION BAR
          const SliverToBoxAdapter(
              child: SizedBox(height: 10), 
          ),
        ],
      ),
    );
  }
}