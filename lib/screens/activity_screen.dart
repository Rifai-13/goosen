import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Halaman ini juga punya Scaffold-nya sendiri
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Activity"),
      ),
      body: const Center(
        child: Text(
          'Halaman Aktivitas',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}