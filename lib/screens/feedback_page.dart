import 'package:flutter/material.dart';
import '../data/student_constants.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
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
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nama wajib diisi'
                      : null,
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