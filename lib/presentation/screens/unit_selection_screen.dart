import 'package:flutter/material.dart';

class UnitSelectionScreen extends StatelessWidget {
  const UnitSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final station = args['station'] as int;
    print('La estación es => $station');

    // Definir el número de unidades según la estación
    int numberOfUnits;
    if (station == 1) {
      numberOfUnits = 6;
    } else if (station == 2) {
      numberOfUnits = 4;
    } else {
      // Manejar el caso en que la estación no es 1 ni 2
      numberOfUnits = 0;
    }

    void goToDataTypeSelection(int unit) {
      print('la estacion seleccionada es $station');
      print('la unidad seleccionada es $unit');
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final operator = args['operator'] as String;
      final date = args['date'] as String;
      final time = args['time'] as String;
      Navigator.pushNamed(
        context,
        '/data_type',
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
        title: const Text('Seleccionar Unidad de Bombeo'),
      ),
      body: ListView.builder(
        itemCount: numberOfUnits,
        itemBuilder: (context, index) {
          final unitNumber = index + 1; // Las unidades empiezan en 1
          return ListTile(
            title: Text('Unidad $unitNumber'),
            onTap: () => goToDataTypeSelection(unitNumber),
          );
        },
      ),
    );
  }
}
