import 'package:flutter/material.dart';

class MyFoodCard extends StatelessWidget {
  // 1. Buat variabel untuk menampung data
  final String imageUrl;
  final String title;
  final String distance;
  final String duration;
  final double rating;
  final String ratingCount;

  // 2. Buat Constructor-nya
  const MyFoodCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.distance,
    required this.duration,
    required this.rating,
    required this.ratingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Tentukan lebar card-nya
      width: 210, 
      margin: const EdgeInsets.only(left: 12.0),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- GAMBAR ----
            Image.network(
              imageUrl,
              height: 140,
              width: 200,
              fit: BoxFit.cover,
            ),

            // ---- JUDUL ----
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ---- INFO JARAK & WAKTU ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "$distance km . $duration min",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ),

            // ---- RATING ----
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  SizedBox(width: 4),
                  Text(
                    rating.toString(), // Tampilkan rating (angka)
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(width: 4),
                  Text(
                    ". $ratingCount+ ratings",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
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