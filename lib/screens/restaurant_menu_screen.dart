import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ==========================================
// 1. MODEL DATA
// ==========================================
class MenuItem {
  final String title;
  final String desc;
  final int price;
  final double rating;
  final String reviewCount;
  final String imageUrl;
  int quantity;

  MenuItem({
    required this.title,
    required this.desc,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.quantity = 0,
  });
}

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
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
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
  const RestaurantMenuScreen({super.key});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  // HAPUS variabel 'bool showCart = true' disini karena tidak perlu.

  // Data Dummy Menu
  final List<MenuItem> _menuItems = [
    MenuItem(
      title: "Chicken katsu Single",
      desc: "Kentang + katsu",
      price: 32000,
      rating: 4.9,
      reviewCount: "100+",
      imageUrl: "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500&q=80",
    ),
    MenuItem(
      title: "Chicken katsu Fries",
      desc: "Kentang + katsu + saus spesial",
      price: 38000,
      rating: 4.8,
      reviewCount: "80+",
      imageUrl: "https://images.unsplash.com/photo-1619860860774-1e7e17343432?w=500&q=80",
    ),
    MenuItem(
      title: "Katsu Mentai Rice",
      desc: "Nasi + Katsu + Saus Mentai",
      price: 45000,
      rating: 4.9,
      reviewCount: "200+",
      imageUrl: "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500&q=80",
    ),
  ];

  // Helper format duit
  String formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(amount);
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

    // 2. LOGIC OTOMATIS: Cek apakah ada item?
    // Kalau totalItems > 0, maka showCart TRUE. Kalau 0, FALSE.
    bool showCart = totalItems > 0; 

    return Scaffold(
      backgroundColor: Colors.white,
      
      // --- FLOATING ACTION BUTTON (ANIMASI SLIDE UP) ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedSlide(
        // Logika: Kalau showCart true, posisi normal (0).
        // Kalau false, turun ke bawah sejauh 2x (hilang).
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
                print("Checkout diklik");
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
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Diantar dari Katsugi Bento...",
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          formatCurrency(totalPrice),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      ],
                    )
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
                        "Makanan",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const DashedLine(color: Color(0xFFCCCCCC), dashWidth: 4.0),
                      const SizedBox(height: 24),

                      // Generate List Menu dari Data
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
                const Expanded(
                  child: Text(
                    "Katsugi Bento by...",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "The people's favorites",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- ITEM MENU WIDGET ---
  Widget _buildMenuItem(int index, MenuItem item) {
    bool isSelected = item.quantity > 0;

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. GARIS HIJAU (Indikator Seleksi)
              if (isSelected)
                Container(
                  width: 4,
                  // height: 145,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

              // 2. KONTEN UTAMA
              Expanded(
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TEKS KIRI
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  "${item.rating} (${item.reviewCount})",
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.desc,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              formatCurrency(item.price),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // GAMBAR KANAN + BUTTON LOGIC
                      Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              item.imageUrl,
                              width: 110, height: 110, fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stack) => Container(width: 110, height: 110, color: Colors.grey[300]),
                            ),
                          ),
                          
                          Positioned(
                            bottom: -32,
                            child: isSelected 
                            // TAMPILAN COUNTER (- 1 +)
                            ? Container(
                                height: 32, 
                                width: 90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          item.quantity--;
                                        });
                                      },
                                      child: const Icon(Icons.remove, color: Colors.green, size: 20),
                                    ),
                                    Text(
                                      "${item.quantity}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          item.quantity++;
                                        });
                                      },
                                      child: const Icon(Icons.add, color: Colors.green, size: 20),
                                    ),
                                  ],
                                ),
                              )
                            // TAMPILAN TOMBOL BIASA (Tambah)
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    item.quantity = 1;
                                  });
                                },
                                child: Container(
                                  height: 32, width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.green, width: 1),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Tambah",
                                      style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 48),
        Divider(thickness: 1, height: 1, color: Colors.grey[300]),
        const SizedBox(height: 16),
      ],
    );
  }
}