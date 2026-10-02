// Pertemuan 5 - Tahap 3: LayoutBuilder & Breakpoint
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
          title: const Text('Tahap 3 - LayoutBuilder'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // ===== Breakpoint =====
            if (constraints.maxWidth < 600) {
              return const CompactLayout();
            } else if (constraints.maxWidth < 840) {
              return const MediumLayout();
            } else {
              return const ExpandedLayout();
            }
          },
        ),
      ),
    );
  }
}

// ===== Layout Compact (< 600px) =====
class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone_android, size: 60, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Compact Layout',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            const Text('(< 600px) - Smartphone'),
            const SizedBox(height: 24),
            Text('$studentId - $studentName',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ===== Layout Medium (600-839px) =====
class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.tablet_android, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Medium Layout',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            const Text('(600-839px) - Tablet Portrait'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('$studentId - $studentName',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Layout Expanded (>= 840px) =====
class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.desktop_windows, size: 100, color: Colors.purple),
            const SizedBox(height: 16),
            const Text(
              'Expanded Layout',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const SizedBox(height: 8),
            const Text('(≥ 840px) - Tablet/Laptop/Desktop'),
            const SizedBox(height: 24),
            Card(
              elevation: 5,
              color: Colors.purple.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('$studentId - $studentName',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}