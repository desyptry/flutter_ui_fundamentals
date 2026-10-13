// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/student_constants.dart';
import '../providers/course_provider.dart';
import '../widgets/home_menu_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final totalCourses = provider.courses.length;
    final totalFavorites = provider.favoriteCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.school, size: 56, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text('Course Explorer v2',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$studentId - $studentName',
              style: const TextStyle(fontSize: 14, color: Colors.grey)),

          const SizedBox(height: 24),

          Row(
            children: [
              // Card 1: Courses
              Expanded(
                child: _SummaryCard(
                  label: 'Courses',
                  value: '$totalCourses',
                  icon: Icons.school,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              // Card 2: Favorites
              Expanded(
                child: _SummaryCard(
                  label: 'Favorites',
                  value: '$totalFavorites',
                  icon: Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          const HomeMenuTile(
            icon: Icons.aspect_ratio,
            title: 'Responsive Layout',
            subtitle: 'Breakpoint compact / medium / expanded',
          ),
          const HomeMenuTile(
            icon: Icons.navigation,
            title: 'Navigation',
            subtitle: 'Navigator.push, pop, passing data',
          ),
          const HomeMenuTile(
            icon: Icons.touch_app,
            title: 'Interaction',
            subtitle: 'InkWell, GestureDetector, favorite',
          ),
          const HomeMenuTile(
            icon: Icons.storage,
            title: 'State Management',
            subtitle: 'Provider + Repository + Service',
          ),
        ],
      ),
    );
  }
}


class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
                Text(label,
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    );
  }
}