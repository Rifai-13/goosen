import 'package:flutter/material.dart';

// --- Data Dummy Makanan ---
class FoodItemData {
  final String imageUrl;
  final String name;
  final String distance;
  final String time;
  final double rating;
  final String ratingCount;

  FoodItemData({
    required this.imageUrl,
    required this.name,
    required this.distance,
    required this.time,
    required this.rating,
    required this.ratingCount,
  });
}

// List Data Makanan (Menggunakan URL Google yang Anda berikan)
final List<FoodItemData> foodItems = [
  FoodItemData(
    imageUrl:
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=500&q=80',
    name: 'Katsugi Bento By Kopi Bambang, La...',
    distance: '2.49 km',
    time: '25-35 min',
    rating: 4.8,
    ratingCount: '3K',
  ),
  FoodItemData(
    imageUrl:
        'https://images.unsplash.com/photo-1563636326618-6c8a3528b80e?w=500&q=80',
    name: 'Nasi Padang Restu Bundo Jl Raya Se...',
    distance: '1.10 km',
    time: '15-25 min',
    rating: 4.8,
    ratingCount: '100+',
  ),
  FoodItemData(
    imageUrl:
        'https://images.unsplash.com/photo-1588166524941-efc88e93d264?w=500&q=80',
    name: 'Steak Wagyu Meltique By The Grill',
    distance: '5.2 km',
    time: '30-40 min',
    rating: 4.6,
    ratingCount: '500+',
  ),
  FoodItemData(
    imageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&q=80',
    name: 'Healthy Salad Bowl By Veggie Delight',
    distance: '0.5 km',
    time: '10-20 min',
    rating: 4.9,
    ratingCount: '1.2K',
  ),
];
// --- Akhir Data Dummy Makanan ---

class AllFoodScreen extends StatelessWidget {
  const AllFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian Header Rating ---
              const Text(
                'Top-rated by other foodies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // --- Bagian Daftar Makanan Dinamis ---
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: foodItems.map((item) {
                  return _buildFoodItem(
                    context: context,
                    imageUrl: item.imageUrl,
                    name: item.name,
                    distance: item.distance,
                    time: item.time,
                    rating: item.rating,
                    ratingCount: item.ratingCount,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat satu item/card makanan (Telah direvisi)
  Widget _buildFoodItem({
    required BuildContext context,
    required String imageUrl,
    required String name,
    required String distance,
    required String time,
    required double rating,
    required String ratingCount,
  }) {
    // Hitung lebar item secara dinamis
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 48) / 2;

    return Container(
      width: itemWidth,
      // Tambahkan BoxDecoration dan Shadow di sini
      decoration: BoxDecoration(
        color: Colors
            .white, // Penting: Berikan warna latar belakang agar shadow terlihat
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.3,
            ), // Warna dan transparansi bayangan
            spreadRadius: 1, // Menyebar bayangan ke luar
            blurRadius:
                4, // Tingkat keburaman bayangan (semakin besar semakin halus)
            offset: const Offset(0, 2), // Posisi bayangan (x, y)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Gambar Makanan
          ClipRRect(
            // Border Radius harus ada di sini dan di Container luar agar sudut terlihat bulat
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl,
              height: itemWidth,
              width: itemWidth,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: itemWidth,
                  width: itemWidth,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: itemWidth,
                width: itemWidth,
                color: Colors.red[100],
                child: const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ),

          // --- Teks di bawah Gambar (tetap sama) ---
          const SizedBox(height: 8),

          // Teks Jarak dan Waktu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '$distance km . $time',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          // ... (Sisa kode untuk Nama dan Rating)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),

          // Bagian Rating
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  ' . ',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  '$ratingCount+ ratings',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Widget untuk membuat AppBar kustom (header)
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120.0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Baris atas: Icon X
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.zero, // Hapus padding default IconButton
                  constraints: const BoxConstraints(), // Hapus batasan default
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () {
                    // Logika untuk menutup layar
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Baris bawah: Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.black54),
                    hintText: 'what food is on your mind?',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                    ), // Sesuaikan tinggi TextField
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
