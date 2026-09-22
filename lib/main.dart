// Tahap 12: Membaca File JSON Statik
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
  final jsonString = await rootBundle.loadString('assets/data/students_data.json');
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Uji coba: baca JSON dan tampilkan di console
    loadStudentData().then((data) {
      debugPrint('===== DATA JSON BERHASIL DIBACA =====');
      debugPrint('Nama: ${data['student']['name']}');
      debugPrint('NIM: ${data['student']['nim']}');
      debugPrint('Jumlah Mata Kuliah: ${data['courses'].length}');
      debugPrint('=====================================');
    }).catchError((error) {
      debugPrint('Gagal memuat JSON: $error');
    });
  }

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
        body: const Center(
          child: Text(
            'Cek Console untuk hasil debugPrint JSON',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}