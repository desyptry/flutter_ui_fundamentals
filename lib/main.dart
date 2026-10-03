// Pertemuan 5 - Tahap 8: Passing Data List ke Detail
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const MyApp());
}

// ===== Pembaca JSON (dari Pertemuan 4) =====
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString =
      await rootBundle.loadString('assets/data/students_data.json');
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const CourseListPage(),
    );
  }
}

// ===== Halaman List Course =====
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat data: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }

          final data = snapshot.data!;
          final courses = data['courses'] as List<dynamic>;

          return Column(
            children: [
              // ===== Header Identitas =====
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

              // ===== List Course =====
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    return _CourseListTile(course: course);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ===== Item List Course (bisa ditekan) =====
class _CourseListTile extends StatelessWidget {
  final Map<String, dynamic> course;
  const _CourseListTile({required this.course});

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String? ?? 'Belum';
    final isDone = status == 'Selesai';
    final isRunning = status == 'Berjalan';

    final IconData icon = isDone
        ? Icons.check_circle
        : isRunning
            ? Icons.play_circle
            : Icons.radio_button_unchecked;

    final Color statusColor = isDone
        ? Colors.green
        : isRunning
            ? Colors.orange
            : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: statusColor, size: 32),
        title: Text(
          course['title'] as String? ?? '-',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${course['code']} • ${course['credits']} SKS'),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 14, color: Colors.grey.shade400),
        // ===== Tap → Navigate ke CourseDetailPage =====
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(course: course),
            ),
          );
        },
      ),
    );
  }
}

// ===== Halaman Detail: Menerima data via constructor =====
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String? ?? 'Belum';
    final isDone = status == 'Selesai';
    final isRunning = status == 'Berjalan';

    final Color statusColor = isDone
        ? Colors.green
        : isRunning
            ? Colors.orange
            : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header Course =====
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle
                              : isRunning
                                  ? Icons.play_circle
                                  : Icons.radio_button_unchecked,
                          color: statusColor,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            course['title'] as String? ?? '-',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow('Kode Mata Kuliah', '${course['code'] ?? '-'}'),
                    const SizedBox(height: 8),
                    _buildInfoRow('SKS', '${course['credits'] ?? 0} SKS'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Status', status, color: statusColor),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== Identitas Mahasiswa (WAJIB TAMPIL) =====
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}