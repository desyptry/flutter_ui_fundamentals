// Tahap 14: Integrasi Aplikasi - Learning Dashboard Final
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Identitas Mahasiswa (WAJIB TAMPIL)
const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const MyApp());
}

// ===== Function Pembaca JSON =====
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
      title: 'Learning Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const DashboardPage(),
    );
  }
}

// ===== DashboardPage: StatefulWidget dengan FutureBuilder =====
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
        title: const Text('Learning Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          // ---- Loading State ----
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ---- Error State ----
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Gagal memuat data: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // ---- Data State ----
          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          // Hitung total SKS
          final totalCredits = courses.fold<int>(0, (sum, item) {
            final course = item as Map<String, dynamic>;
            return sum + ((course['credits'] as num?)?.toInt() ?? 0);
          });

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ===== Kartu Identitas =====
                _IdentityCard(student: student),

                const SizedBox(height: 16),

                // ===== Summary Card (Topik & SKS) =====
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        label: 'Topik',
                        value: '${courses.length}',
                        icon: Icons.topic,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        label: 'Total SKS',
                        value: '$totalCredits',
                        icon: Icons.credit_score,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ===== Judul Daftar Materi =====
                const Text(
                  'Daftar Materi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // ===== List Mata Kuliah dari JSON =====
                ...courses.map(
                  (course) => _CourseCard(
                    course: course as Map<String, dynamic>,
                  ),
                ),

                const SizedBox(height: 8),

                // ===== Footer =====
                const Text(
                  'Data list dimuat dari JSON statik',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ===== Widget: Kartu Identitas =====
class _IdentityCard extends StatelessWidget {
  final Map<String, dynamic> student;

  const _IdentityCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NIM: ${student['nim'] ?? studentId}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student['name'] as String? ?? studentName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student['program'] as String? ?? 'Mobile Programming',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Widget: Summary Card =====
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ===== Widget: Kartu Mata Kuliah =====
class _CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const _CourseCard({required this.course});

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

    final Color color = isDone
        ? Colors.green
        : isRunning
            ? Colors.orange
            : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(
          course['title'] as String? ?? '-',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${course['code'] ?? '-'} • ${course['credits'] ?? 0} SKS'),
        trailing: Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}