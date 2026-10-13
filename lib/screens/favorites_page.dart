// lib/screens/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseProvider>();
    final favorites = state.favorites;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 28),
              const SizedBox(width: 8),
              Text(
                'Favorites (${favorites.length})',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('Belum ada course favorit',
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 6),
                      Text(
                        'Tap ikon hati di tab Courses.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: favorites.map((title) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading:
                            const Icon(Icons.favorite, color: Colors.red),
                        title: Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            context
                                .read<CourseProvider>()
                                .toggleFavorite(title);
                          },
                          tooltip: 'Hapus dari favorit',
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}