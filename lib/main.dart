// Tahap 13: Future, late, dan FutureBuilder
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
      debugShowCheckedModeBanner: false,
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

          return Column(
            children: [
              // Identitas dari JSON
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(student['name'] as String),
                subtitle: Text('NIM: ${student['nim']}'),
              ),
              const Divider(),

              // List mata kuliah dari JSON
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(Icons.book, color: Colors.blue),
                      title: Text(course['title'] as String),
                      subtitle: Text(
                          '${course['code']} • ${course['credits']} SKS'),
                      trailing: Text(course['status'] as String),
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