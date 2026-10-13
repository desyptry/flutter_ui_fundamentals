import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;

  // ===== Constructor: terima Service =====
  CourseRepository(this.service);

  // ===== Method getCourses: perantara ke Service =====
  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}