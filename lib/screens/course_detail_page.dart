import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/student_constants.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/info_row.dart';
import 'course_form_page.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  Future<void> _confirmDelete(BuildContext context, Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Course?'),
        content: Text(
          'Course "${course.title}" (${course.code}) akan dihapus permanen. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // 2. Panggil provider untuk delete
    final success = await context
        .read<CourseProvider>()
        .deleteCourse(course.id!);

    if (!context.mounted) return;

    // 3. Tampilkan feedback
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course berhasil dihapus!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // kembali ke list
    } else {
      final error = context.read<CourseProvider>().error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal: ${error ?? "Unknown error"}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = course.isDone
        ? Colors.green
        : course.isActive
            ? Colors.blue
            : Colors.orange;

    final isFav = context.watch<CourseProvider>().isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Course',
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(initialCourse: course),
                ),
              );
              if (result == true && context.mounted) {
                // Kembali ke list agar ter-refresh
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus Course',
            onPressed: () => _confirmDelete(context, course),
          ),
          IconButton(
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(course.code);
            },
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.white,
            ),
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
                    if (course.createdAt != null) ...[
                      const SizedBox(height: 8),
                      InfoRow(
                          label: 'Dibuat',
                          value: course.createdAt!.substring(0, 10)),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            
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

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseFormPage(initialCourse: course),
                    ),
                  );
                  if (result == true && context.mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            
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