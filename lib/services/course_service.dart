import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/course.dart';

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

class CourseService {
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