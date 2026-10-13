// Pertemuan 6 - Tahap 9: Service / Data Source
// File: lib/services/course_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/course.dart';

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

class CourseService {
  // ===== TAHAP 9: Service bertanggung jawab baca data JSON =====
  Future<List<Course>> loadCourses() async {
    final jsonString =
        await rootBundle.loadString('assets/data/students_data.json');

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;
    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}