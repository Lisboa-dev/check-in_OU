import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import 'shell_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ShellScreen()),
          );
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in OU')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: state.isLoading
                  ? null
                  : () => ref.read(authControllerProvider.notifier).login(_email.text.trim(), _password.text.trim()),
              child: state.isLoading ? const CircularProgressIndicator() : const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
