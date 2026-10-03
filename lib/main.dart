// Pertemuan 5 - Tahap 6: Scrollable Content & Keyboard
import 'package:flutter/material.dart';

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ProfileFormPage(),
    );
  }
}

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final TextEditingController namaCtrl = TextEditingController(text: studentName);
  final TextEditingController nimCtrl = TextEditingController(text: studentId);
  final TextEditingController bioCtrl = TextEditingController();
  final TextEditingController alamatCtrl = TextEditingController();
  final TextEditingController hobiCtrl = TextEditingController();
  final TextEditingController catatanCtrl = TextEditingController();

  @override
  void dispose() {
    namaCtrl.dispose();
    nimCtrl.dispose();
    bioCtrl.dispose();
    alamatCtrl.dispose();
    hobiCtrl.dispose();
    catatanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6 - Scroll & Keyboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // ===== SingleChildScrollView: bungkus seluruh body =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header Identitas =====
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 56, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                studentName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'NIM: $studentId',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            // ===== Form Fields =====
            const Text('Nama Lengkap',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan nama',
              ),
            ),
            const SizedBox(height: 16),

            const Text('NIM',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: nimCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan NIM',
              ),
            ),
            const SizedBox(height: 16),

            const Text('Bio',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: bioCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tulis bio singkat',
              ),
            ),
            const SizedBox(height: 16),

            const Text('Alamat',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: alamatCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Alamat',
              ),
            ),
            const SizedBox(height: 16),

            const Text('Hobi',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: hobiCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Hobi',
              ),
            ),
            const SizedBox(height: 16),

            const Text('Catatan Tambahan',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: catatanCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Catatan tambahan',
              ),
            ),

            const SizedBox(height: 24),

            // ===== Tombol Simpan (di bawah sekali) =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil disimpan')),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
              ),
            ),

            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Scroll untuk lihat semua field. Coba fokus ke field bawah lalu buka keyboard.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}