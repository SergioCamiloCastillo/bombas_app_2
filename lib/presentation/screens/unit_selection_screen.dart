import 'package:flutter/material.dart';

class UnitSelectionScreen extends StatelessWidget {
  const UnitSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final station = args['station'] as int;

    // Definir el número de unidades según la estación
    int numberOfUnits;
    if (station == 1) {
      numberOfUnits = 6;
    } else if (station == 2) {
      numberOfUnits = 4;
    } else {
      numberOfUnits = 0;
    }

    void goToDataTypeSelection(int unit) {
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
        backgroundColor: const Color(0xFF1E3A8A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Seleccionar unidad de bombeo',
          
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
            // Título con información de la estación
            Center(
              child: Column(
                children: [
                  Text(
                    'Estación #$station',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Selecciona una unidad',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Botones de unidades
            Expanded(
              child: ListView.builder(
                itemCount: numberOfUnits,
                itemBuilder: (context, index) {
                  final unitNumber = index + 1; // Las unidades empiezan en 1

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.bolt, color: Colors.blue.shade700),
                        title: Text(
                          'Unidad $unitNumber',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Color(0xFF64748B)),
                        onTap: () => goToDataTypeSelection(unitNumber),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
