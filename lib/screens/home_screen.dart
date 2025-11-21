import 'package:flutter/material.dart';
import '../widgets/my_food_card.dart';
import '../widgets/home_appbar.dart';
import '../screens/all_food_screen.dart';

final List<Map<String, dynamic>> dummyFoodData = [
  {
    "image":
        "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&q=80",
    "distance": "2.49",
    "duration": "25-35",
    "title": "Katsugi Bento By Kopi Bambang, La...",
    "rating": 4.8,
    "count": "3k",
  },
  {
    "image":
        "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=500&q=80",
    "distance": "1.10",
    "title": "Nasi Padang Restu Bundo Jl Raya Se...",
    "duration": "15-25",
    "rating": 4.8,
    "count": "100",
  },
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: HomeAppBar(searchController: _searchController, showProfile: true,),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
              // Header Section
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/banner.png',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

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
              // Top-rated section
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final food = dummyFoodData[index % dummyFoodData.length];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: MyFoodCard(
                        imageUrl: food['image'],
                        distance: food['distance'],
                        duration: food['duration'],
                        title: food['title'],
                        rating: food['rating'],
                        ratingCount: food['count'],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
