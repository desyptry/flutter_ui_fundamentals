// Pertemuan 5 - Tahap 16: Debugging Challenge
// File terpisah untuk eksperimen 4 kasus debugging.
import 'package:flutter/material.dart';

const String studentName = 'Desy_Putri';
const String studentId = '2415051002';

void main() {
  runApp(const DebugApp());
}

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const DebugHomePage(),
    );
  }
}

class DebugHomePage extends StatelessWidget {
  const DebugHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debugging Challenge'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('$studentId - $studentName',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _menuTile(context, 'Kasus A - RenderFlex Overflow',
              const KasusAOverflow()),
          _menuTile(context, 'Kasus B - Unbounded Height ListView',
              const KasusBUnbounded()),
          _menuTile(context, 'Kasus C - Keyboard Overflow',
              const KasusCKeyboard()),
          _menuTile(context, 'Kasus D - Double Navigation',
              const KasusDDoubleNav()),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext context, String title, Widget page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.bug_report, color: Colors.red),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}

// =========================================================
// KASUS A: RenderFlex Overflow pada Row dengan teks panjang
// =========================================================
class KasusAOverflow extends StatelessWidget {
  const KasusAOverflow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus A - Overflow')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('❌ Versi Salah (overflow):',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 8),
            // ❌ Row tanpa Expanded → Text akan overflow
            Row(
              children: [
                const Icon(Icons.info),
                const SizedBox(width: 8),
                Text(
                  '$studentId - $studentName - teks sangat panjang yang bikin overflow di layar kecil sekali',
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('✅ Versi Benar (dengan Expanded):',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 8),
            // ✅ Text dibungkus Expanded → teks wrap
            Row(
              children: [
                const Icon(Icons.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$studentId - $studentName - teks sangat panjang yang bikin overflow di layar kecil sekali',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// KASUS B: ListView di dalam Column TANPA Expanded
// =========================================================
// Versi ini SENGAJA salah → untuk memunculkan error
// "Vertical viewport was given unbounded height".
class KasusBUnbounded extends StatelessWidget {
  const KasusBUnbounded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus B - Unbounded')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Header di atas ListView',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // ✅ DENGAN Expanded → tidak error
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, i) => ListTile(
                leading: const Icon(Icons.circle),
                title: Text('Item ke-${i + 1}'),
                subtitle: Text('$studentId - $studentName'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// KASUS C: Keyboard Overflow pada form di bawah layar
// =========================================================
class KasusCKeyboard extends StatelessWidget {
  const KasusCKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus C - Keyboard')),
      // ✅ SingleChildScrollView → form bisa di-scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('$studentId - $studentName',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            for (int i = 1; i <= 8; i++) ...[
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Field',
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

// =========================================================
// KASUS D: Double Navigation (route ter-push berulang)
// =========================================================
class KasusDDoubleNav extends StatefulWidget {
  const KasusDDoubleNav({super.key});

  @override
  State<KasusDDoubleNav> createState() => _KasusDDoubleNavState();
}

class _KasusDDoubleNavState extends State<KasusDDoubleNav> {
  bool _isNavigating = false;

  Future<void> _openDetail() async {
    if (_isNavigating) return; // ← guard
    setState(() => _isNavigating = true);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Detail Page')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ini halaman detail'),
                const SizedBox(height: 8),
                Text('$studentId - $studentName'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!mounted) return;
    setState(() => _isNavigating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus D - Double Nav')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$studentId - $studentName',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              const Text(
                'Tanpa guard, tap cepat beberapa kali akan membuka banyak DetailPage.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                // ✅ Tombol di-disable saat navigasi
                onPressed: _isNavigating ? null : _openDetail,
                child: Text(_isNavigating ? 'Membuka...' : 'Buka Detail'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}