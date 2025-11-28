// lib/models/menu_item.dart (Buat file baru atau taruh di tempat yang bisa diakses global)

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