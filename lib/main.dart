// Tahap 8: Reusable Widget
import 'package:flutter/material.dart';

// Identitas Mahasiswa (WAJIB TAMPIL)
const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter UI Fundamentals'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ===== Kartu Profil =====
                _buildProfileCard(),
                const SizedBox(height: 16),

                // ===== Kartu Statistik (pakai reusable widget) =====
                _buildStatistikCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== Reusable Widget: Kartu Profil =====
  Widget _buildProfileCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 46,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 52, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              studentName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              studentId,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.phone_android, color: Colors.blue),
                SizedBox(width: 8),
                Text('Mobile Programming Student'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== Reusable Widget: Kartu Statistik =====
  Widget _buildStatistikCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Statistik Belajar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Menggunakan reusable widget buildStatCard (3x)
                buildStatCard('8', 'Widget', Icons.widgets),
                buildStatCard('4', 'Layout', Icons.view_quilt),
                buildStatCard('1', 'State', Icons.sync),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Reusable Function (dari worksheet) =====
Widget buildStatCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}