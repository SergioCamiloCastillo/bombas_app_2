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
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>?;

        switch (settings.name) {
          case '/temperature':
            return MaterialPageRoute(
              builder: (context) => TemperatureScreen(
                station: args?['station'] ?? '',
                unit: args?['unit'] ?? '',
              ),
            );
          case '/pressure':
            return MaterialPageRoute(
              builder: (context) => PressureDataScreen(
                station: args?['station'] ?? '',
                unit: args?['unit'] ?? '',
              ),
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
