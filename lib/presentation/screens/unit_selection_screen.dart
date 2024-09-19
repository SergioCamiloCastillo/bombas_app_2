import 'package:flutter/material.dart';

class UnitSelectionScreen extends StatelessWidget {
  const UnitSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final station = args['station'] as String;

    void goToDataTypeSelection(String unit) {
      Navigator.pushNamed(
        context,
        '/data_type',
        arguments: {'station': station, 'unit': unit},
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Unidad de Bombeo'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Unidad 1'),
            onTap: () => goToDataTypeSelection('Unidad 1'),
          ),
          ListTile(
            title: const Text('Unidad 2'),
            onTap: () => goToDataTypeSelection('Unidad 2'),
          ),
          // Agrega más unidades si es necesario
        ],
      ),
    );
  }
}