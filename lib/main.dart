// Pertemuan 5 - Tahap 2: MediaQuery
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
          title: const Text('Tahap 2 - MediaQuery'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ===== Baca ukuran layar dengan MediaQuery =====
                Builder(
                  builder: (context) {
                    final size = MediaQuery.of(context).size;
                    final orientation = MediaQuery.of(context).orientation;
                    final isCompact = size.width < 600;

                    return Column(
                      children: [
                        // Identitas
                        Text(
                          '$studentId - $studentName',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Info layar
                        Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Icon(Icons.phone_android,
                                    size: 40, color: Colors.blue),
                                const SizedBox(height: 12),
                                Text(
                                  'Width: ${size.width.toStringAsFixed(0)} px',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Height: ${size.height.toStringAsFixed(0)} px',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Orientation: $orientation',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isCompact
                                        ? Colors.green.shade100
                                        : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isCompact ? 'Compact' : 'Wide',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isCompact
                                          ? Colors.green.shade800
                                          : Colors.orange.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          'Putar layar (portrait ↔ landscape) untuk melihat perubahan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}