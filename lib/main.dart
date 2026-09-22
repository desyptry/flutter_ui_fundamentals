// Tahap 10: Menampilkan List dari Collection Dart
import 'package:flutter/material.dart';

// Identitas Mahasiswa (WAJIB TAMPIL)
const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const MyApp());
}

// ===== Collection Dart: Daftar Topik =====
final List<Map<String, dynamic>> topics = [
  {'title': 'Git & GitHub', 'subtitle': 'Version control', 'done': true},
  {'title': 'Dart Fundamentals', 'subtitle': 'Language basics', 'done': true},
  {'title': 'Flutter UI Fundamentals', 'subtitle': 'Widgets & layout', 'done': false},
  {
    'title': '$studentId - $studentName',
    'subtitle': 'Pemilik aplikasi',
    'done': false
  },
];

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
        body: Column(
          children: [
            // ===== Identitas di atas list =====
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '$studentId - $studentName',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // ===== ListView.builder =====
            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final item = topics[index];
                  return ListTile(
                    leading: Icon(
                      item['done'] == true
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: item['done'] == true ? Colors.green : Colors.grey,
                    ),
                    title: Text(item['title'] as String),
                    subtitle: Text(item['subtitle'] as String),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}