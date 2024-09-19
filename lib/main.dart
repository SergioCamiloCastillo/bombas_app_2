import 'package:bombas2/presentation/screens/data_type_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bombas2/presentation/screens/operator_screen.dart';
import 'package:bombas2/presentation/screens/station_selection_screen.dart';
import 'package:bombas2/presentation/screens/unit_selection_screen.dart';
import 'package:bombas2/presentation/screens/temperature_screen.dart';
import 'package:bombas2/presentation/screens/pressure_screen.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => OperatorScreen(),
          '/station': (context) => const StationSelectionScreen(),
          '/unit': (context) => const UnitSelectionScreen(),
          '/data_type': (context) => const DataTypeSelectionScreen(),
        },
        onGenerateRoute: (settings) {
          final args = settings.arguments as Map<String, dynamic>?;

          // Convertir 'station' a int de forma segura
          final station = args?['station'] is String
              ? int.tryParse(args?['station'] as String) ?? 0
              : (args?['station'] as int?) ?? 0;
          final unit = args?['unit'] is String
              ? int.tryParse(args?['unit'] as String) ?? 0
              : (args?['unit'] as int?) ?? 0;

          switch (settings.name) {
            case '/temperature':
              return MaterialPageRoute(
                builder: (context) => TemperatureScreen(
                  station: station,
                  unit: unit,
                  operator: args?['operator'] as String,
                  date: args?['date'] as String,
                  time: args?['time'] as String,
                ),
              );
            case '/pressure':
              return MaterialPageRoute(
                builder: (context) => PressureDataScreen(
                  station: station,
                  unit: unit,
                ),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(child: Text('Página no encontrada')),
                ),
              );
          }
        });
  }
}
