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