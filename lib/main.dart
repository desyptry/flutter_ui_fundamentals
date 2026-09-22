// Tahap 11: Membuat List Lebih Informatif
import 'package:flutter/material.dart';

// Identitas Mahasiswa (WAJIB TAMPIL)
const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const MyApp());
}

// ===== Collection Dart: Daftar Mata Kuliah =====
final List<Map<String, dynamic>> courses = [
  {
    'title': 'Git & GitHub',
    'code': 'GIT101',
    'credits': 2,
    'status': 'Selesai',
    'done': true,
  },
  {
    'title': 'Dart Fundamentals',
    'code': 'DART101',
    'credits': 3,
    'status': 'Selesai',
    'done': true,
  },
  {
    'title': 'Flutter UI Fundamentals',
    'code': 'FLUT101',
    'credits': 3,
    'status': 'Berjalan',
    'done': false,
  },
  {
    'title': 'Layout & Widget Lanjutan',
    'code': 'FLUT102',
    'credits': 3,
    'status': 'Berjalan',
    'done': false,
  },
  {
    'title': '$studentId - $studentName',
    'code': 'OWNER',
    'credits': 0,
    'status': 'Pemilik aplikasi',
    'done': false,
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
          title: const Text('Learning Dashboard'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // ===== Identitas di atas list =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'NIM: $studentId',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== Header Daftar Materi =====
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Daftar Materi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ===== ListView.separated =====
            Expanded(
              child: ListView.separated(
                itemCount: courses.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final isDone = course['done'] == true;
                  final statusColor = isDone ? Colors.green : Colors.orange;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListTile(
                      leading: Icon(
                        isDone ? Icons.check_circle : Icons.play_circle,
                        color: statusColor,
                      ),
                      title: Text(
                        course['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${course['code']} • ${course['credits']} SKS',
                      ),
                      trailing: Text(
                        course['status'] as String,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Data list dimuat dari collection Dart',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}