import 'package:bombas2/presentation/providers/local_data_source_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class DataReviewScreen extends ConsumerWidget {
  final String dataType; // Asegúrate de tener este parámetro

  const DataReviewScreen({super.key, required this.dataType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener instancia de LocalDataSource
    final localDataSource = ref.watch(localDataSourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisión de Datos Guardados'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Llama al método adecuado según el tipo de datos
        future: dataType == 'temperature'
            ? localDataSource.getAllTemperatures() // Obtiene las temperaturas
            : localDataSource.getAllPressures(), // Obtiene las presiones
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos guardados'));
          } else {
            // Lista de datos según el tipo
            final data = snapshot.data!;

            return ListView(
              children: [
                ListTile(
                  title: Text(dataType == 'temperature'
                      ? 'Datos de Temperatura'
                      : 'Datos de Presión'),
                  tileColor: Colors.orangeAccent,
                ),
                ...data.map((item) {
                  return ListTile(
                    title: Text('Estación: ${item['station']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Unidad: ${item['unit']}'),
                        Text('Fecha: ${item['date']}'),
                        Text('Hora: ${item['time']}'),
                        if (dataType == 'pressure') ...[
                          Text('Lubricación Bomba: ${item['lubricacionBomba']}'),
                          Text('Refrigeración Motor: ${item['refrigeracionMotor']}'),
                          Text('Descarga Bomba: ${item['descargaBomba']}'),
                          Text('Sello Mecánico: ${item['selloMecanico']}'),
                        ] else ...[
                          Text('Cojinete Soporte: ${item['cojineteSoporte']}'),
                          Text('Cojinete Superior: ${item['cojineteSuperior']}'),
                          Text('Cojinete Inferior: ${item['cojineteInferior']}'),
                          Text('Soporte Bomba: ${item['soporteBomba']}'),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            );
          }
        },
      ),
    );
  }
}