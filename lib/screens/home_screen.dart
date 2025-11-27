import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/menu_makanan.dart';
import '../widgets/my_food_card.dart';
import '../widgets/home_appbar.dart';
import '../screens/all_food_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  // 1. Variabel untuk menampung data API
  List<MenuMakanan> listTopRated = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchTopRatedFoods(); // 2. Panggil fungsi ambil data saat aplikasi dibuka
  }

  // 3. Fungsi Ambil Data (Sama kayak di AllFoodScreen)
  Future<void> fetchTopRatedFoods() async {
    try {
      final String urlAPI = dotenv.env['API_URL'] ?? '';
      final response = await http.get(Uri.parse(urlAPI));

      if (response.statusCode == 200) {
        final List<dynamic> dataJSON = json.decode(response.body);
        setState(() {
          // Kita mapping JSON ke Model
          listTopRated = dataJSON
              .map((json) => MenuMakanan.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      print("Error ambil data home: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        searchController: _searchController,
        showProfile: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Deals to see when you\'re hungry',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Header Section (Banner Gambar)
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/banner.png', // Pastikan gambar ini ada di assets kamu
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[300],
                    ), // Placeholder kalau gambar error
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Bagian Judul "Top Rated" dan tombol "See All"
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top Rated',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllFoodScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Bagian List Makanan Horizontal (Top Rated)
              SizedBox(
                height: 250,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Loading spinner
                    : listTopRated.isEmpty
                    ? const Center(child: Text("Belum ada menu hits nih"))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: listTopRated.length > 5
                            ? 5
                            : listTopRated.length,
                        itemBuilder: (context, index) {
                          final food = listTopRated[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: MyFoodCard(
                              // Data dari API
                              imageUrl: food.gambar,
                              title: food.nama,
                              rating: food.rating,
                              distance: food.distance,
                              duration: food.duration,
                              ratingCount: food.terjual,
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
