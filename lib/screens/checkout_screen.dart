import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/menu_item.dart'; // Import model MenuItem

// File screen lain (sesuaikan path)
import 'location_screen.dart';
import 'payment_screen.dart';
import 'order_success_screen.dart';
import 'note_pesanan_screen.dart';
import 'note_delivery_screen.dart';

// ==========================================
// 1. MODEL DATA DELIVERY
// ==========================================
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

const String deliveryAddress = "Jalan Raya Dadaprejo No .293";

// ==========================================
// 2. CHECKOUT SCREEN (STATEFUL)
// ==========================================
class CheckoutScreen extends StatefulWidget {
  final int initialSubtotal;

  // DATA DINAMIS DARI RESTAURANT MENU
  final List<MenuItem> cartItems;
  final String orderTitle; // Buat ganti judul AppBar

  const CheckoutScreen({
    super.key,
    required this.initialSubtotal,
    required this.cartItems,
    required this.orderTitle,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedDeliveryIndex = 1;
  String _currentPaymentMethod = 'Cash Money';
  String _itemNote = '';
  String _deliveryNote = '';

  final Map<String, IconData> _paymentIcons = {
    'Cash Money': Icons.money,
    'Gopay': Icons.phone_android,
    'Credit Card': Icons.credit_card,
  };

  late int _subtotal;
  late int _deliveryFee;
  late int _total;

  @override
  void initState() {
    super.initState();
    _subtotal = widget.initialSubtotal;
    _calculatePrices(deliveryOptions[_selectedDeliveryIndex].price);
  }

  String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp.',
      decimalDigits: 0,
    ).format(amount);
  }

  void _calculatePrices(int newDeliveryFee) {
    _deliveryFee = newDeliveryFee;
    _total = _subtotal + _deliveryFee;
  }

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

  // --- APP BAR (JUDUL SESUAI MAKANAN) ---
  SliverAppBar _buildCustomAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.orderTitle, // <--- INI SUDAH DINAMIS SESUAI MAKANAN
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          option.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                          option.duration,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                          ),
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
      ),
    );
  }

  Widget _buildDeliveryLocationContent(BuildContext context) {
    final String noteButtonLabel = _deliveryNote.isNotEmpty
        ? 'edit catatan'
        : 'Catatan';

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
              onPressed: () async {
                final newNote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NoteDeliveryScreen(initialNote: _deliveryNote),
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
                color: Colors.white,
              ),
              label: Text(
                noteButtonLabel,
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
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationScreen(),
                  ),
                );
              },
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

  // --- ITEM SUMMARY (BAGIAN INI YANG JADI DINAMIS TAPI TAMPILAN TETAP SAMA) ---
  Widget _buildItemSummaryContent() {
    final String itemNoteButtonLabel = _itemNote.isNotEmpty
        ? 'edit catatan'
        : 'Catatan';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LOOPING CART ITEMS (GANTIKAN DATA DUMMY)
        ...widget.cartItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0), // Spasi antar item
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title, // NAMA MAKANAN
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                            formatCurrency(item.price), // HARGA
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'item : ${item.quantity}', // JUMLAH
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),

        // const SizedBox(height: 8),

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
    IconData currentIcon =
        _paymentIcons[_currentPaymentMethod] ?? Icons.credit_card_outlined;

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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

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
        physics: const ClampingScrollPhysics(),
        slivers: [
          _buildCustomAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate([
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

              _buildCardWrapper(
                padding: const EdgeInsets.all(16.0),
                child: _buildDeliveryLocationContent(context),
              ),

              // INI ISI SUMMARY MAKANAN YANG DINAMIS
              _buildCardWrapper(
                padding: const EdgeInsets.all(16.0),
                child: _buildItemSummaryContent(),
              ),

              _buildCardWrapper(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: _buildPaymentMethodTile(context),
              ),

              _buildCardWrapper(
                child: _buildPriceSummary(),
                padding: const EdgeInsets.all(16.0),
              ),
            ]),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
        ],
      ),
    );
  }
}
