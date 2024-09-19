import 'package:flutter/material.dart';

class StationSelectionScreen extends StatelessWidget {
  const StationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void goToUnitSelection(String station) {
      Navigator.pushNamed(
        context,
        '/unit',
        arguments: {'station': station},
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Estación de Bombeo'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Estación 1'),
            onTap: () => goToUnitSelection('Estación 1'),
          ),
          ListTile(
            title: const Text('Estación 2'),
            onTap: () => goToUnitSelection('Estación 2'),
          ),
        ],
      ),
    );
  }
}