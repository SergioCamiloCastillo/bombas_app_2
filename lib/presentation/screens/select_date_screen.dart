import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bombas2/presentation/providers/local_data_source_provider.dart'; // Asegúrate de tener esto
import 'package:bombas2/presentation/screens/generate_excel_screen.dart'; // Importa la pantalla para generar Excel

class SelectDateScreen extends ConsumerWidget {
  const SelectDateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localDataSource = ref.watch(localDataSourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Fecha'),
      ),
      body: FutureBuilder<List<String>>(
        future: Future.wait([
          localDataSource.getUniquePressureDates(),
          localDataSource.getUniqueTemperatureDates(),
        ]).then((results) {
          final List<String> pressureDates =
              results[0].cast<String>(); // Asegúrate de que es List<String>
          final List<String> temperatureDates =
              results[1].cast<String>(); // Asegúrate de que es List<String>
          return <String>{...pressureDates, ...temperatureDates}
              .toList(); // Combinando y eliminando duplicados
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final dates = snapshot.data!;

          if (dates.isEmpty) {
            return const Center(child: Text('No hay fechas disponibles.'));
          }

          return ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              return ListTile(
                title: Text(date),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateExcelScreen(
                          date: date), // Pasar la fecha seleccionada
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
