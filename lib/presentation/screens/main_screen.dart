import 'package:flutter/material.dart';
import 'package:bombas2/presentation/screens/select_data_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Datos de Bombeo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectStationScreen()),
              ),
              child: const Text('Registrar Datos'),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectStationScreen extends StatelessWidget {
  const SelectStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Estación de Bombeo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectUnitScreen(station: 1),
                ),
              ),
              child: const Text('Estación 1'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectUnitScreen(station: 1),
                ),
              ),
              child: const Text('Estación 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectUnitScreen extends StatelessWidget {
  final int station;

  const SelectUnitScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Unidad de Bombeo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(6, (index) {
            return ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectDataScreen(
                    station: station,
                    unit: index + 1,
                  ),
                ),
              ),
              child: Text('Unidad ${index + 1}'),
            );
          }),
        ),
      ),
    );
  }
}
