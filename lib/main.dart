// Pertemuan 5 - Tahap 1: Hard-coded layout (sengaja salah)
import 'package:flutter/material.dart';

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
          title: const Text('Tahap 1 - Hard-coded Layout'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Container(
            width: double.infinity, 
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade100,
            child: Text(
              '$studentId - $studentName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}