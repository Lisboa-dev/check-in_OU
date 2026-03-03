import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DriverScanScreen extends StatefulWidget {
  const DriverScanScreen({super.key});

  @override
  State<DriverScanScreen> createState() => _DriverScanScreenState();
}

class _DriverScanScreenState extends State<DriverScanScreen> {
  String lastValue = 'Nenhum QR lido ainda';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condutor - Scan em lote')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final code = capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
                if (code != null) {
                  setState(() => lastValue = code);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Último QR: $lastValue'),
          ),
        ],
      ),
    );
  }
}
