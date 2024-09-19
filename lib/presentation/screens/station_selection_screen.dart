import 'package:flutter/material.dart';

class StationSelectionScreen extends StatelessWidget {
  const StationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void goToUnitSelection(int station) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final operator = args['operator'] as String;
      final date = args['date'] as String;
      final time = args['time'] as String;
      Navigator.pushNamed(
        context,
        '/unit',
        arguments: {
          'station': station,
          'operator': operator,
          'date': date,
          'time': time
        },
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
            onTap: () => goToUnitSelection(1),
          ),
          ListTile(
            title: const Text('Estación 2'),
            onTap: () => goToUnitSelection(2),
          ),
        ],
      ),
    );
  }
}
