import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Dashboard de Sincronização')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(child: ListTile(title: Text('Pendentes de sincronização'), subtitle: Text('0 (exemplo local)'))),
            Card(child: ListTile(title: Text('Alunos por rota'), subtitle: Text('Consome /admin/dashboard'))),
            Card(child: ListTile(title: Text('Universidades com mais demanda'), subtitle: Text('Consome /admin/dashboard'))),
          ],
        ),
      ),
    );
  }
}
