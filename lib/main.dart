import 'package:bombas2/presentation/screens/data_type_selection_screen.dart';
import 'package:bombas2/presentation/screens/date_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bombas2/presentation/screens/operator_screen.dart';
import 'package:bombas2/presentation/screens/station_selection_screen.dart';
import 'package:bombas2/presentation/screens/unit_selection_screen.dart';
import 'package:bombas2/presentation/screens/temperature_screen.dart';
import 'package:bombas2/presentation/screens/pressure_screen.dart';
import 'package:bombas2/presentation/screens/select_date_screen.dart'; // Importa SelectDateScreen

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Bombas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0F9FD),
        primaryColor: const Color(0xFF1E3A8A),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OperatorScreen(),
        '/station': (context) => const StationSelectionScreen(),
        '/unit': (context) => const UnitSelectionScreen(),
        '/data_type': (context) => const DataTypeSelectionScreen(),
        '/select_data': (context) => const DataTypeSelectionScreen(),
        '/select_dates': (context) => const SelectDateScreen(),
        '/select_date': (context) =>
            const SelectDateScreen(), // Nueva ruta para SelectDateScreen
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>?;

        // Verifica que los argumentos no sean nulos
        if (args == null) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text('No se recibieron argumentos')),
            ),
          );
        }

        // Convertir 'station' y 'unit' a int de forma segura
        final station = (args['station'] is String)
            ? int.tryParse(args['station'] as String) ?? 0
            : (args['station'] as int?) ?? 0;

        final unit = (args['unit'] is String)
            ? int.tryParse(args['unit'] as String) ?? 0
            : (args['unit'] as int?) ?? 0;

        switch (settings.name) {
          case '/temperature':
            return MaterialPageRoute(
              builder: (context) => TemperatureScreen(
                station: station,
                unit: unit,
                operator: args['operator'] as String,
                date: args['date'] as String,
                time: args['time'] as String,
              ),
            );
          case '/pressure':
            return MaterialPageRoute(
              builder: (context) => PressureDataScreen(
                station: station,
                unit: unit,
                operator: args['operator'] as String,
                date: args['date'] as String,
                time: args['time'] as String,
              ),
            );
          case '/data_review':
            return MaterialPageRoute(
              builder: (context) =>
                  DataReviewScreen(dataType: args['dataType'] as String),
            );

          default:
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Página no encontrada')),
              ),
            );
        }
      },
    );
  }
}
