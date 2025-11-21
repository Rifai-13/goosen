import 'package:flutter/material.dart';
import '../widgets/home_appbar.dart';
import '../screens/restaurant_menu_screen.dart';

// ==========================================
// 1. DEFINISI CLASS MODEL & DATA DUMMY
// ==========================================

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

// ==========================================
// 2. SCREEN UTAMA
// ==========================================

class AllFoodScreen extends StatefulWidget {
  const AllFoodScreen({super.key});

  @override
  State<AllFoodScreen> createState() => _AllFoodScreenState();
}

class _AllFoodScreenState extends State<AllFoodScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // App Bar Reuse
      appBar: HomeAppBar(
        searchController: _searchController,
        showProfile: false, // Profile Hilang
        // Tombol X di sebelah kiri Search, Sejajar
        customLeading: IconButton(
          icon: const Icon(Icons.close, size: 28, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top-rated by other foodies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Grid Makanan
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: foodItems.map((item) {
                  return _buildFoodItem(
                    context: context,
                    item: item,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodItem({
    required BuildContext context,
    required FoodItemData item,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Rumus lebar card (total lebar - padding kiri kanan - spasi tengah) / 2
    final itemWidth = (screenWidth - 32 - 16) / 2;

return GestureDetector(
      onTap: () {
        // 2. Navigasi ke halaman Detail Menu
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RestaurantMenuScreen(),
          ),
        );
      },

child: Container(
        width: itemWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                item.imageUrl,
                height: itemWidth,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) => Container(
                  height: itemWidth,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            // Info Teks
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.distance} • ${item.time}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${item.ratingCount})',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}