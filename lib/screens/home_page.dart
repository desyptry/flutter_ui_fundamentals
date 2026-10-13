import 'package:flutter/material.dart';
import '../data/student_constants.dart';
import '../widgets/home_menu_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.school, size: 56, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text('Course Explorer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$studentId - $studentName',
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
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
            icon: Icons.feedback,
            title: 'Feedback',
            subtitle: 'Form + validasi + SnackBar/Dialog',
          ),
        ],
      ),
    );
  }
}