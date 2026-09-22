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
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==== Profil Mahasiswa (dari Tahap 5) ====
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

              const SizedBox(height: 24),

              // ==== Bagian Statistik (Tahap 6) ====
              const Text(
                'Statistik Belajar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Row dengan 3 item statistik
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  // Item 1: Widget
                  Column(
                    children: [
                      Text('8', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('Widget'),
                    ],
                  ),
                  // Item 2: Layout
                  Column(
                    children: [
                      Text('4', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('Layout'),
                    ],
                  ),
                  // Item 3: State
                  Column(
                    children: [
                      Text('1', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('State'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}