import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../domain/entities/student_form.dart';
import '../controllers/student_controller.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen> {
  final _university = TextEditingController();
  final _route = TextEditingController(text: 'centro');
  final _schedule = TextEditingController(text: '18:00');

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(studentControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Aluno')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _university, decoration: const InputDecoration(labelText: 'Universidade')),
          TextField(controller: _route, decoration: const InputDecoration(labelText: 'Rota (centro/br)')),
          TextField(controller: _schedule, decoration: const InputDecoration(labelText: 'Horário (HH:mm)')),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () async {
              await ref.read(studentControllerProvider.notifier).saveForm(
                    StudentForm(university: _university.text, route: _route.text, schedule: _schedule.text),
                  );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Formulário salvo (online ou em fila offline).')),
                );
              }
            },
            child: const Text('Salvar formulário'),
          ),
          const SizedBox(height: 12),
          const Text('QR (local):'),
          QrImageView(data: 'checkin://student/local-preview', size: 140),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => ref.read(studentControllerProvider.notifier).loadHistory(1),
            child: const Text('Carregar histórico'),
          ),
          const SizedBox(height: 8),
          historyState.when(
            data: (items) => Column(
              children: items
                  .map((e) => ListTile(title: Text('Presença #${e.id}'), subtitle: Text(e.scannedAt.toIso8601String())))
                  .toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Erro ao carregar histórico: $e'),
          ),
        ],
      ),
    );
  }
}
