// Pertemuan 6 - Tahap 11: Provider untuk Async State
// File: lib/providers/course_state.dart
import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

class CourseProvider extends ChangeNotifier {
  // ===== Dependency: Repository =====
  final CourseRepository repository;

  CourseProvider(this.repository);

  // ===== State: courses (async data) =====
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // ===== State: favorites (dari Tahap 5) =====
  final Set<String> favorites = {};

  bool isFavorite(String id) => favorites.contains(id);

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }

  int get favoriteCount => favorites.length;

  // ===== TAHAP 11: Load courses async =====
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    Future<void> loadCourses() async {
      isLoading = true;
      error = null;
      notifyListeners();
    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
}