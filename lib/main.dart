// Pertemuan 6 - Tahap 1: identifikasi local dan shared state
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const MyApp());
}

// ===== Pembaca JSON =====
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
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const AdaptiveShell(),
    );
  }
}

// ===== AdaptiveShell: NavigationBar/Rail + favorites state =====
class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key});

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  int currentIndex = 0;
  final Set<String> favorites = {};

  void toggleFavorite(String title) {
    setState(() {
      favorites.contains(title)
          ? favorites.remove(title)
          : favorites.add(title);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeTab(),
      CoursesTab(favorites: favorites, onToggleFavorite: toggleFavorite),
      const FeedbackFormTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
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
          }
          return _buildExpandedLayout(pages);
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
              icon: Icon(Icons.feedback_outlined),
              selectedIcon: Icon(Icons.feedback),
              label: Text('Feedback'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: pages[currentIndex]),
      ],
    );
  }

  static const _navBarDestinations = [
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
      icon: Icon(Icons.feedback_outlined),
      selectedIcon: Icon(Icons.feedback),
      label: 'Feedback',
    ),
  ];
}

// ===== TAB 1: Home =====
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.school, size: 56, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text('Course Explorer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$studentId - $studentName',
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          const _HomeMenuTile(
            icon: Icons.aspect_ratio,
            title: 'Responsive Layout',
            subtitle: 'Breakpoint compact / medium / expanded',
          ),
          const _HomeMenuTile(
            icon: Icons.navigation,
            title: 'Navigation',
            subtitle: 'Navigator.push, pop, passing data',
          ),
          const _HomeMenuTile(
            icon: Icons.touch_app,
            title: 'Interaction',
            subtitle: 'InkWell, GestureDetector, favorite',
          ),
          const _HomeMenuTile(
            icon: Icons.feedback,
            title: 'Feedback',
            subtitle: 'Form + validasi + SnackBar/Dialog',
          ),
        ],
      ),
    );
  }
}

class _HomeMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _HomeMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

// ===== TAB 2: Courses (GridView Responsif) =====
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
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  // ===== Jumlah kolom berdasarkan breakpoint =====
  int columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
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

        final allCourses = snapshot.data!['courses'] as List<dynamic>;
        final filtered = allCourses.where((c) {
          final title = (c['title'] as String).toLowerCase();
          return title.contains(searchQuery.toLowerCase());
        }).toList();

        return Column(
          children: [
            // ===== Header Identitas + Search =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            Text('NIM: $studentId',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ===== Search Field =====
                  TextField(
                    onChanged: (v) => setState(() => searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search courses...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ],
              ),
            ),

            // ===== GridView Responsif =====
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = columnsFor(constraints.maxWidth);
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada course yang cocok',
                          style: TextStyle(color: Colors.grey)),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: columns == 1 ? 2.5 : (columns == 2 ? 1.8 : 1.5),
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final course = filtered[index] as Map<String, dynamic>;
                      final title = course['title'] as String;
                      final isFav = widget.favorites.contains(title);

                      return _CourseGridCard(
                        course: course,
                        isFavorite: isFav,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CourseDetailPage(course: course),
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
                                'Status: ${course['status']}',
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
                        onFavoriteTap: () =>
                            widget.onToggleFavorite(title),
                      );
                    },
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

// ===== Card Grid (dengan InkWell + GestureDetector + Favorite) =====
class _CourseGridCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavoriteTap;

  const _CourseGridCard({
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
    final statusColor =
        isDone ? Colors.green : isRunning ? Colors.orange : Colors.grey;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isDone
                          ? Icons.check_circle
                          : isRunning
                              ? Icons.play_circle
                              : Icons.radio_button_unchecked,
                      color: statusColor,
                      size: 20,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onFavoriteTap,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  course['title'] as String? ?? '-',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${course['code']} • ${course['credits']} SKS',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Detail Page =====
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String? ?? 'Belum';
    final statusColor = status == 'Selesai' ? Colors.green : Colors.orange;

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

// ===== TAB 3: Feedback Form (dari Tahap 14) =====
class FeedbackFormTab extends StatefulWidget {
  const FeedbackFormTab({super.key});

  @override
  State<FeedbackFormTab> createState() => _FeedbackFormTabState();
}

class _FeedbackFormTabState extends State<FeedbackFormTab> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController namaCtrl =
      TextEditingController(text: studentName);
  final TextEditingController nimCtrl =
      TextEditingController(text: studentId);
  final TextEditingController komentarCtrl = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    namaCtrl.dispose();
    nimCtrl.dispose();
    komentarCtrl.dispose();
    super.dispose();
  }

  Future<bool> _showConfirmDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Kirim feedback ini sekarang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _submitForm() async {
    if (!formKey.currentState!.validate()) return;
    final confirmed = await _showConfirmDialog();
    if (!confirmed) return;

    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Feedback berhasil dikirim!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    komentarCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.feedback, size: 56, color: Colors.blue),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text('Form Feedback',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text('$studentId - $studentName',
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey)),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                const Text('Nama',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: namaCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                const Text('NIM',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: nimCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'NIM wajib diisi';
                    if (v.trim().length < 8) return 'NIM minimal 8 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text('Komentar',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: komentarCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tulis komentar minimal 5 karakter...',
                    alignLabelWithHint: true,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Komentar wajib diisi';
                    }
                    if (v.trim().length < 5) {
                      return 'Komentar minimal 5 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _submitForm,
                    icon: const Icon(Icons.send),
                    label: const Text('Kirim Feedback'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Mengirim feedback...'),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}