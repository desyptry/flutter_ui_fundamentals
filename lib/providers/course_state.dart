// Pertemuan 6 - Tahap 5: ChangeNotifier
// File: lib/providers/course_state.dart
import 'package:flutter/foundation.dart';

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

// ===== TAHAP 5: ChangeNotifier =====
// State dan method perubahan state ditempatkan pada class terpisah.
// Setelah state berubah, panggil notifyListeners().
class CourseState extends ChangeNotifier {
  // ===== Collection favorites =====
  final Set<String> favorites = {};

  // ===== Getter untuk cek apakah course sudah difavorite =====
  bool isFavorite(String id) => favorites.contains(id);

  // ===== Method toggleFavorite =====
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    // ===== WAJIB: notifyListeners dipanggil setelah state berubah =====
    notifyListeners();
  }

  // ===== Getter jumlah favorite =====
  int get favoriteCount => favorites.length;
}