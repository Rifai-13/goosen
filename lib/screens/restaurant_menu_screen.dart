import 'package:flutter/material.dart';

// --- 1. WIDGET DASHED LINE (GARIS PUTUS-PUTUS) ---
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

// --- 2. SCREEN UTAMA ---
class RestaurantMenuScreen extends StatelessWidget {
  const RestaurantMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Kita pakai SafeArea agar tidak tertutup notifikasi bar HP
      body: SafeArea(
        child: Column(
          children: [
            // ==============================================
            // BAGIAN 1: HEADER YANG DIAM (FIXED / STICKY)
            // ==============================================
            Container(
              padding: const EdgeInsets.only(bottom: 16), // Jarak bawah header
              decoration: BoxDecoration(
                color: Colors.white,
                // Efek bayangan tipis di bawah header biar kelihatan 'melayang'
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
                  // A. Baris Tombol Back, Judul, Search
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
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  // B. Teks "The people's favorites" (DIMASUKKAN SINI BIAR DIAM)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "The people's favorites",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // ==============================================
            // BAGIAN 2: KONTEN YANG BISA DI-SCROLL
            // ==============================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Judul Kategori Makanan
                      const Text(
                        "Makanan",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      
                      const SizedBox(height: 8),

                      // Garis Putus-putus
                      const DashedLine(
                        color: Color(0xFFCCCCCC),
                        dashWidth: 4.0,
                      ),
                      
                      const SizedBox(height: 24),

                      // --- List Menu Items ---
                      _buildMenuItem(
                        context,
                        title: "Chicken katsu Single",
                        desc: "Kentang + katsu",
                        price: "32.000",
                        rating: "4.9",
                        reviewCount: "100+",
                        imageUrl: "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500&q=80",
                      ),
                      _buildMenuItem(
                        context,
                        title: "Chicken katsu Fries",
                        desc: "Kentang + katsu + saus spesial",
                        price: "38.000",
                        rating: "4.8",
                        reviewCount: "80+",
                        imageUrl: "https://images.unsplash.com/photo-1619860860774-1e7e17343432?w=500&q=80",
                      ),
                      _buildMenuItem(
                        context,
                        title: "Katsu Mentai Rice",
                        desc: "Nasi + Katsu + Saus Mentai",
                        price: "45.000",
                        rating: "4.9",
                        reviewCount: "200+",
                        imageUrl: "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500&q=80",
                      ),
                      // Tambahan item biar kelihatan scroll-nya
                      _buildMenuItem(
                        context,
                        title: "Double Katsu Jumbo",
                        desc: "Porsi double buat yang laper banget",
                        price: "55.000",
                        rating: "5.0",
                        reviewCount: "50+",
                        imageUrl: "https://images.unsplash.com/photo-1588166524941-efc88e93d264?w=500&q=80",
                      ),
                      _buildMenuItem(
                        context,
                        title: "Double Katsu Jumbo",
                        desc: "Porsi double buat yang laper banget",
                        price: "55.000",
                        rating: "5.0",
                        reviewCount: "50+",
                        imageUrl: "https://images.unsplash.com/photo-1588166524941-efc88e93d264?w=500&q=80",
                      ),
                      _buildMenuItem(
                        context,
                        title: "Double Katsu Jumbo",
                        desc: "Porsi double buat yang laper banget",
                        price: "55.000",
                        rating: "5.0",
                        reviewCount: "50+",
                        imageUrl: "https://images.unsplash.com/photo-1588166524941-efc88e93d264?w=500&q=80",
                      ),
                      _buildMenuItem(
                        context,
                        title: "Double Katsu Jumbo",
                        desc: "Porsi double buat yang laper banget",
                        price: "55.000",
                        rating: "5.0",
                        reviewCount: "50+",
                        imageUrl: "https://images.unsplash.com/photo-1588166524941-efc88e93d264?w=500&q=80",
                      ),
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

  // --- WIDGET CUSTOM ITEM MENU ---
  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String desc,
    required String price,
    required String rating,
    required String reviewCount,
    required String imageUrl,
  }) {
    return Column(
      children: [
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KIRI: TEKS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "$rating ($reviewCount)",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // KANAN: GAMBAR + BUTTON
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      imageUrl,
                      width: 110, height: 110, fit: BoxFit.cover,
                      errorBuilder: (ctx, error, stack) => Container(width: 110, height: 110, color: Colors.grey[300]),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    child: Container(
                      height: 32, width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: const Center(
                        child: Text("Tambah", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 46),
        Divider(
          thickness: 1,
          height: 1,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}