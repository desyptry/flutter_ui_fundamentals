// Pertemuan 5 - Tahap 9: Returning Data dari Screen
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const MyApp());
}

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

  // ===== State: Set of title yang di-favorite =====
  final Set<String> favoriteCourses = {};

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  // ===== Function: Buka Detail & Tangkap Hasil =====
  Future<void> _openDetail(Map<String, dynamic> course) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(course: course),
      ),
    );

    // ===== Kalau result true, tambahkan ke favorite & tampilkan SnackBar =====
    if (result == true) {
      setState(() {
        favoriteCourses.add(course['title'] as String);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${course['title']}" ditambahkan ke favorit'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                    // ===== Info jumlah favorite =====
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite,
                              size: 14, color: Colors.red),
                          const SizedBox(width: 4),
                          Text('${favoriteCourses.length}'),
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
                    final isFavorite =
                        favoriteCourses.contains(course['title']);
                    return _CourseListTile(
                      course: course,
                      isFavorite: isFavorite,
                      onTap: () => _openDetail(course),
                    );
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

// ===== Item List =====
class _CourseListTile extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onTap;

  const _CourseListTile({
    required this.course,
    required this.isFavorite,
    required this.onTap,
  });

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
        trailing: isFavorite
            ? const Icon(Icons.favorite, color: Colors.red)
            : const Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

// ===== Halaman Detail =====
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
            // ===== Card Detail Course =====
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

            // ===== Card Identitas Mahasiswa =====
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

            const SizedBox(height: 24),

            // ===== Tombol "Pilih/Favorite" → pop dengan result true =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Kembali sambil mengirim nilai true
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.favorite),
                label: const Text('Tambahkan ke Favorit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ===== Tombol Kembali tanpa result =====
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ),

            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Contoh lain: pop(result) bisa dipakai untuk mengirim hasil edit form, memilih item dari daftar, atau mengonfirmasi suatu aksi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey),
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
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}