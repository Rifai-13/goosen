import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/menu_makanan.dart';
import 'checkout_screen.dart';
import '../models/menu_item.dart';

// ==========================================
// 2. WIDGET DASHED LINE
// ==========================================
class DashedLine extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;

  const DashedLine({
    super.key,
    this.height = 1,
    this.dashWidth = 4.0,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

// ==========================================
// 3. SCREEN UTAMA (STATEFUL)
// ==========================================
class RestaurantMenuScreen extends StatefulWidget {
  // TERIMA DATA DARI HALAMAN SEBELUMNYA
  final MenuMakanan selectedMenu; 

  const RestaurantMenuScreen({super.key, required this.selectedMenu});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  // List Menu Lokal
  late List<MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    
    // SETUP DATA: Masukkan data yang dipilih user sebagai ITEM PERTAMA
    // Kita tambahkan juga item pelengkap (Nasi/Minum) biar kayak resto beneran
    _menuItems = [
      // ITEM 1: Makanan yang dipilih user
      MenuItem(
        title: widget.selectedMenu.nama,
        desc: widget.selectedMenu.deskripsi, // Ambil deskripsi asli
        price: widget.selectedMenu.harga,
        rating: widget.selectedMenu.rating,
        reviewCount: widget.selectedMenu.terjual, // Pake data terjual
        imageUrl: widget.selectedMenu.gambar,
        quantity: 0, 
      ),
      // ITEM 2: Item Tambahan (Dummy statis biar menu gak sepi)
      MenuItem(
        title: "Nasi Putih",
        desc: "Nasi putih pulen hangat.",
        price: 5000,
        rating: 4.5,
        reviewCount: "5k+",
        imageUrl: "https://images.unsplash.com/photo-1516684732162-798a0062be99?w=500&q=80",
      ),
      // ITEM 3: Minuman (Dummy)
      MenuItem(
        title: "Es Teh Manis",
        desc: "Teh manis segar dengan es batu kristal.",
        price: 4000,
        rating: 4.8,
        reviewCount: "10k+",
        imageUrl: "https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=500&q=80",
      ),
    ];
  }

  // Helper format duit
  String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ', // Tambah simbol Rp biar jelas
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Hitung Total Item & Harga
    int totalItems = 0;
    int totalPrice = 0;
    for (var item in _menuItems) {
      totalItems += item.quantity;
      totalPrice += (item.price * item.quantity);
    }

    bool showCart = totalItems > 0;

    return Scaffold(
      backgroundColor: Colors.white,

      // --- FLOATING ACTION BUTTON (CART) ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedSlide(
        offset: showCart ? Offset.zero : const Offset(0, 2),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,

        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.green[700],
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                if (totalItems > 0) {
                  final List<MenuItem> cartItems = _menuItems.where((item) => item.quantity > 0).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CheckoutScreen(initialSubtotal: totalPrice, cartItems: cartItems, orderTitle: widget.selectedMenu.nama,),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$totalItems item",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Siap diantar...",
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          formatCurrency(totalPrice),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // HEADER FIX
            _buildStickyHeader(context),

            // LIST MENU
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        "Menu Pilihan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const DashedLine(
                        color: Color(0xFFCCCCCC),
                        dashWidth: 4.0,
                      ),
                      const SizedBox(height: 24),

                      // Generate List Menu
                      ..._menuItems.asMap().entries.map((entry) {
                        int index = entry.key;
                        MenuItem item = entry.value;
                        return _buildMenuItem(index, item);
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER WIDGET ---
  Widget _buildStickyHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    // GUNAKAN NAMA MAKANAN YANG DIPILIH
                    widget.selectedMenu.nama,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.timer, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  widget.selectedMenu.duration,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16, color: Colors.green),
                 const SizedBox(width: 4),
                Text(
                  widget.selectedMenu.distance,
                   style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- ITEM MENU WIDGET (TIDAK ADA PERUBAHAN LOGIC DISINI, CUMA UI) ---
  Widget _buildMenuItem(int index, MenuItem item) {
    bool isSelected = item.quantity > 0;

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSelected)
                Container(
                  width: 4,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

              Expanded(
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${item.rating} (${item.reviewCount})",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.desc,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              formatCurrency(item.price),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 140,
                        width: 110,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                item.imageUrl,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, error, stack) => Container(
                                  width: 110,
                                  height: 110,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: isSelected
                                  ? Container(
                                      height: 32,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                item.quantity--;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                          ),
                                          Text(
                                            "${item.quantity}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                item.quantity++;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          item.quantity = 1;
                                        });
                                      },
                                      child: Container(
                                        height: 32,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Tambah",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Divider(thickness: 1, height: 1, color: Colors.grey[300]),
        const SizedBox(height: 16),
      ],
    );
  }
}