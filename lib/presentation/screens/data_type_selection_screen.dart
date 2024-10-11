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
        backgroundColor: const Color(0xFFF0F9FD),
        title: const Text(
          'Seleccionar Tipo de Dato',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Texto de bienvenida
            // Card de selección de Temperatura
            _buildSelectionCard(
              context,
              icon: Icons.thermostat,
              label: 'Temperatura',
              color: Colors.orangeAccent,
              onTap: goToTemperatureScreen,
            ),
            const SizedBox(height: 20),
            // Card de selección de Presión
            _buildSelectionCard(
              context,
              icon: Icons.speed,
              label: 'Presión',
              color: Colors.lightBlueAccent,
              onTap: goToPressureScreen,
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir una tarjeta de selección
  Widget _buildSelectionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              // Ícono
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              // Texto
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const Spacer(),
              // Flecha
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF1E3A8A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
