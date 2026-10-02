// Pertemuan 5 - Tahap 4: Expanded, Flexible, dan Wrap
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
          title: const Text('Tahap 4 - Expanded, Flexible, Wrap'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Identitas =====
              Text(
                '$studentId - $studentName',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ===== Bagian 1: Expanded 2:1 =====
              const Text(
                '1. Expanded dengan rasio 2:1',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildPanel('A', Colors.blue),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: _buildPanel('B', Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ===== Bagian 2: Flexible =====
              const Text(
                '2. Flexible (tidak selalu memenuhi ruang)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: _buildPanel('Flexible', Colors.orange),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade300,
                    child: const Text('Fixed 100px'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ===== Bagian 3: Wrap dengan 6 Chip =====
              const Text(
                '3. Wrap dengan 6 Chip skill',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text('Flutter')),
                  Chip(label: Text('Dart')),
                  Chip(label: Text('Git')),
                  Chip(label: Text('JSON')),
                  Chip(label: Text('Layout')),
                  Chip(label: Text('Navigator')),
                ],
              ),
              const SizedBox(height: 24),

              // ===== Bagian 4: Perbandingan Row vs Wrap =====
              const Text(
                '4. Perbandingan Row biasa (bisa overflow) vs Wrap',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade50,
                child: Row(
                  children: const [
                    Chip(label: Text('Flutter')),
                    Chip(label: Text('Dart')),
                    Chip(label: Text('Git')),
                    Chip(label: Text('JSON')),
                    Chip(label: Text('Layout')),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green.shade50,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    Chip(label: Text('Flutter')),
                    Chip(label: Text('Dart')),
                    Chip(label: Text('Git')),
                    Chip(label: Text('JSON')),
                    Chip(label: Text('Layout')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Helper Widget =====
  Widget _buildPanel(String label, Color color) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}