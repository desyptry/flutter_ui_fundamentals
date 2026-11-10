// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart'; 
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';
import 'services/auth_service.dart'; 
import 'screens/adaptive_shell.dart';
import 'screens/login_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  
  final apiService = CourseApiService('https://course-api-pearl.vercel.app');
  final repository = CourseRepository(apiService);

  runApp(
    MultiProvider(
      providers: [
        
        ChangeNotifierProvider(create: (_) => CourseProvider(repository)..loadCourses()),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      
     
      home: AuthService.instance.isLoggedIn
          ? const AdaptiveShell()
          : const LoginPage(),
    );
  }
}