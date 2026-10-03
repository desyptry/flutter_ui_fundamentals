// Pertemuan 5 - Tahap 12: Interaction pada Course Explorer
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const MyApp());
}

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString =
      await rootBundle.loadString('assets/data/students_data.json');
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const AdaptiveShell(),
    );
  }
}

// ===== AdaptiveShell (dari Tahap 11) =====
class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key});

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  int currentIndex = 0;

  // ===== State favorite dibagi ke CoursesTab =====
  final Set<String> favorites = {};

  void toggleFavorite(String title) {
    setState(() {
      if (favorites.contains(title)) {
        favorites.remove(title);
      } else {
        favorites.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pages dibuat on-the-fly agar bisa sharing state `favorites`
    final pages = [
      const HomeTab(),
      CoursesTab(favorites: favorites, onToggleFavorite: toggleFavorite),
      ProfileTab(favoritesCount: favorites.length),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // ===== Counter favorite di AppBar =====
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 18),
                const SizedBox(width: 4),
                Text('${favorites.length}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 840) {
            return _buildCompactLayout(pages);
          } else {
            return _buildExpandedLayout(pages);
          }
        },
      ),
    );
  }

  Widget _buildCompactLayout(List<Widget> pages) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => setState(() => currentIndex = i),
        destinations: _navBarDestinations,
      ),
    );
  }

  Widget _buildExpandedLayout(List<Widget> pages) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: currentIndex,
          onDestinationSelected: (i) => setState(() => currentIndex = i),
          labelType: NavigationRailLabelType.all,
          leading: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school),
              label: Text('Courses'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: Text('Profile'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: pages[currentIndex]),
      ],
    );
  }

  static const List<NavigationDestination> _navBarDestinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.school_outlined),
      selectedIcon: Icon(Icons.school),
      label: 'Courses',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];
}

// ===== TAB 1: Home =====
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.home, size: 56, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text('Selamat Datang!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$studentId - $studentName',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ===== TAB 2: Courses (dengan Interaction) =====
class CoursesTab extends StatefulWidget {
  final Set<String> favorites;
  final Function(String) onToggleFavorite;

  const CoursesTab({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: studentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Gagal: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }

        final courses = snapshot.data!['courses'] as List<dynamic>;

        return Column(
          children: [
            // ===== Header identitas =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(studentName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('NIM: $studentId',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== List Course dengan interaksi =====
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index] as Map<String, dynamic>;
                  final title = course['title'] as String;
                  final isFav = widget.favorites.contains(title);

                  return _InteractiveCourseCard(
                    course: course,
                    isFavorite: isFav,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailPage(course: course),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(title),
                          content: Text(
                            'Kode: ${course['code']}\n'
                            'SKS: ${course['credits']}\n'
                            'Status: ${course['status']}\n\n'
                            'Long press terdeteksi!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                    onFavoriteTap: () => widget.onToggleFavorite(title),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ===== Course Card dengan InkWell + GestureDetector + IconButton =====
class _InteractiveCourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavoriteTap;

  const _InteractiveCourseCard({
    required this.course,
    required this.isFavorite,
    required this.onTap,
    required this.onLongPress,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String? ?? 'Belum';
    final isDone = status == 'Selesai';
    final isRunning = status == 'Berjalan';
    final statusColor = isDone
        ? Colors.green
        : isRunning
            ? Colors.orange
            : Colors.grey;

    return GestureDetector(
      // ===== Long press untuk info tambahan =====
      onLongPress: onLongPress,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          // ===== Tap untuk buka detail (dengan ripple) =====
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  isDone
                      ? Icons.check_circle
                      : isRunning
                          ? Icons.play_circle
                          : Icons.radio_button_unchecked,
                  color: statusColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title'] as String? ?? '-',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${course['code']} • ${course['credits']} SKS',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // ===== IconButton Favorite =====
                IconButton(
                  onPressed: onFavoriteTap,
                  tooltip: isFavorite ? 'Hapus favorit' : 'Tambah favorit',
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Halaman Detail (dari Tahap 8) =====
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String? ?? 'Belum';
    final statusColor =
        status == 'Selesai' ? Colors.green : Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course['title'] as String? ?? '-',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    _infoRow('Kode', '${course['code'] ?? '-'}'),
                    const SizedBox(height: 8),
                    _infoRow('SKS', '${course['credits'] ?? 0} SKS'),
                    const SizedBox(height: 8),
                    _infoRow('Status', status, color: statusColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(studentName),
                subtitle: Text('NIM: $studentId'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

// ===== TAB 3: Profile =====
class ProfileTab extends StatelessWidget {
  final int favoritesCount;
  const ProfileTab({super.key, required this.favoritesCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 68, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(studentName,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('NIM: $studentId',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('$favoritesCount course difavorite',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}