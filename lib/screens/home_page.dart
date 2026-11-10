// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../services/profile_service.dart';
import '../widgets/home_menu_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Gagal memuat profil'));
        }

        final profile = snapshot.data!;
        final courseProvider = context.watch<CourseProvider>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Kartu Identitas (Nama, Email, Role) =====
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(profile.name.isEmpty ? profile.email : profile.name),
                  subtitle: Text('${profile.email} • ${profile.role.toUpperCase()}'),
                ),
              ),
              const SizedBox(height: 16),

              // ===== Tombol Berdasarkan Role =====
              // Hanya owner/admin yang bisa menambah course
              if (profile.isOwner || profile.isAdmin)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigasi ke halaman form course (jika ada)
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseFormPage()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fitur Tambah Course hanya untuk Owner/Admin')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Course Baru'),
                  ),
                ),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              // ===== Menu / Konten Aplikasi =====
              const Text(
                'Course Explorer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Selamat datang, ${profile.name.isEmpty ? profile.email : profile.name}!',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              
              const HomeMenuTile(
                icon: Icons.aspect_ratio,
                title: 'Responsive Layout',
                subtitle: 'Breakpoint compact / medium / expanded',
              ),
              const HomeMenuTile(
                icon: Icons.navigation,
                title: 'Navigation',
                subtitle: 'Navigator.push, pop, passing data',
              ),
              const HomeMenuTile(
                icon: Icons.touch_app,
                title: 'Interaction',
                subtitle: 'InkWell, GestureDetector, favorite',
              ),
              const HomeMenuTile(
                icon: Icons.feedback,
                title: 'Feedback',
                subtitle: 'Form + validasi + SnackBar/Dialog',
              ),
            ],
          ),
        );
      },
    );
  }
}