import 'package:flutter/material.dart';
import 'package:bombas2/presentation/screens/temperature_screen.dart';
import 'package:bombas2/presentation/screens/pressure_screen.dart';

class SelectDataScreen extends StatelessWidget {
  final int station;
  final int unit;

  const SelectDataScreen({super.key, required this.station, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Tipo de Dato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TemperatureScreen(
                    station: station,
                    unit: unit,
                    operator: 'dd',
                    date: 'dd',
                    time: 'dd',

                  ),
                ),
              ),
              child: const Text('Registrar Temperatura'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TemperatureScreen(
                    station: station,
                    unit: unit,
                    operator: 'dd',
                    date: 'dd',
                    time: 'dd',
                  ),
                ),
              ),
              child: const Text('Registrar Presión'),
            ),
          ],
        ),
      ),
    );
  }
}