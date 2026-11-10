// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'adaptive_shell.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await AuthService.instance.login(
        email: _emailC.text.trim(),
        password: _passC.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AdaptiveShell()),
        (route) => false,
      );
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Terjadi kesalahan. Periksa koneksi internet Anda.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Course Explorer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.school, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Welcome to Course Explorer',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Email wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passC,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : _login,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                ),
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                child: const Text('Belum punya akun? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}