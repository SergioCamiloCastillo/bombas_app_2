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
        backgroundColor: const Color(0xFF1E3A8A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Seleccionar estación de bombeo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    'Seleccione una estación',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Elige la estación que deseas gestionar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Tarjetas para las estaciones
            Expanded(
              child: ListView(
                children: [
                  // Tarjeta para la Estación 1
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.location_on,
                          color: Colors.green.shade700, size: 30),
                      title: const Text(
                        'Estación 1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Color(0xFF64748B)),
                      onTap: () => goToUnitSelection(1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tarjeta para la Estación 2
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.location_on,
                          color: Colors.blue.shade700, size: 30),
                      title: const Text(
                        'Estación 2',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Color(0xFF64748B)),
                      onTap: () => goToUnitSelection(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
