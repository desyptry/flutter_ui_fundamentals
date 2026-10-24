import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

class CourseApiService {
  final String baseUrl;

  CourseApiService(this.baseUrl);
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List;
      return data
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Gagal mengambil course: HTTP ${response.statusCode}');
  }
}