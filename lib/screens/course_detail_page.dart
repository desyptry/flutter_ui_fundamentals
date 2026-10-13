// lib/screens/course_detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/student_constants.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/info_row.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final statusColor = course.isDone ? Colors.green : Colors.orange;

    // ===== TAHAP 13: baca status favorite dari Provider =====
    final isFav = context.watch<CourseProvider>().isFavorite(course.title);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        // ===== TAHAP 13: ikon hati di AppBar =====
        actions: [
          IconButton(
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(course.title);
            },
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.white,
            ),
            tooltip: isFav ? 'Hapus dari favorit' : 'Tambah ke favorit',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Card: Info Course =====
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    InfoRow(label: 'Kode', value: course.code),
                    const SizedBox(height: 8),
                    InfoRow(label: 'SKS', value: '${course.credits} SKS'),
                    const SizedBox(height: 8),
                    InfoRow(
                        label: 'Status',
                        value: course.status,
                        color: statusColor),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== Card: Identitas Mahasiswa =====
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(studentName),
                subtitle: Text('NIM: $studentId'),
              ),
            ),

            const SizedBox(height: 20),

            // ===== TAHAP 13: Tombol Favorite besar =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<CourseProvider>().toggleFavorite(course.title);
                },
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                ),
                label: Text(
                  isFav ? 'Hapus dari Favorit' : 'Tambahkan ke Favorit',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFav ? Colors.red : Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ===== Tombol Kembali =====
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}