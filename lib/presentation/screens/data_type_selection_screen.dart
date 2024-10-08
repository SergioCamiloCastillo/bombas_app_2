import 'package:flutter/material.dart';

class DataTypeSelectionScreen extends StatelessWidget {
  const DataTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final station = args['station'] as int;
    final unit = args['unit'] as int;
    final operator = args['operator'] as String;
    final date = args['date'] as String;
    final time = args['time'] as String;

    void goToTemperatureScreen() {
      Navigator.pushNamed(
        context,
        '/temperature',
        arguments: {
          'station': station,
          'unit': unit,
          'operator': operator,
          'date': date,
          'time': time
        },
      );
    }

    void goToPressureScreen() {
      Navigator.pushNamed(
        context,
        '/pressure',
        arguments: {
          'station': station,
          'unit': unit,
          'operator': operator,
          'date': date,
          'time': time
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Tipo de Dato'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Temperatura'),
            onTap: goToTemperatureScreen,
          ),
          ListTile(
            title: const Text('Presión'),
            onTap: goToPressureScreen,
          ),
        ],
      ),
    );
  }
}
