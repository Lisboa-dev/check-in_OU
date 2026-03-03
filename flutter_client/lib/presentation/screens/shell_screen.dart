import 'package:flutter/material.dart';

import 'admin_dashboard_screen.dart';
import 'driver_scan_screen.dart';
import 'student_home_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    const pages = [StudentHomeScreen(), DriverScanScreen(), AdminDashboardScreen()];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.school), label: 'Aluno'),
          NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Condutor'),
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Admin'),
        ],
      ),
    );
  }
}
