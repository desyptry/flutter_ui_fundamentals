// Pertemuan 6 - Tahap 8: Model Course
// File: lib/models/course.dart

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

class Course {
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });


  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
    );
  }


  bool get isDone => status == 'Selesai';
  bool get isRunning => status == 'Berjalan';
}