import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';
import 'services/course_supabase_service.dart';   // ← TETAP ADA
import 'screens/adaptive_shell.dart';
import 'services/course_supabase_service.dart'; 

const String apiBaseUrl = 'https://course-api-pearl.vercel.app';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // ===== UJI SEMENTARA: DELETE di Supabase =====
  try {
    final supabaseService = CourseSupabaseService();
    
    // Ambil list dulu
    final before = await supabaseService.getCourses();
    debugPrint('=====================================');
    debugPrint('DELETE TEST');
    debugPrint('Total course sebelum: ${before.length}');
    
    if (before.isEmpty) {
      debugPrint('✗ Tidak ada course untuk dihapus');
    } else {
      final target = before.last;
      debugPrint('Target: [${target.id}] ${target.title}');
      
      // Delete
      await supabaseService.deleteCourse(target.id!);
      debugPrint('✓ DELETE BERHASIL');
      
      // Verifikasi
      final after = await supabaseService.getCourses();
      debugPrint('Total course sesudah: ${after.length}');
      final stillExists = after.any((c) => c.id == target.id);
      debugPrint('Target masih ada? ${stillExists ? "YA (gagal)" : "TIDAK (sukses)"}');
    }
    debugPrint('=====================================');
  } catch (e) {
    debugPrint('✗ Error: $e');
  }
  // =============================================

  final apiService = CourseApiService(apiBaseUrl);
  final repository = CourseRepository(apiService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const AdaptiveShell(),
    );
  }
}