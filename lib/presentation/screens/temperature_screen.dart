import 'package:flutter/material.dart';
import 'package:bombas2/presentation/providers/temperature_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Para el formateo de fecha y hora
import 'package:bombas2/domain/entities/temperature.dart';

class TemperatureScreen extends ConsumerWidget {
  final int station;
  final int unit;
  final String operator;
  final String date;
  final String time;

  const TemperatureScreen(
      {super.key,
      required this.station,
      required this.unit,
      required this.operator,
      required this.date,
      required this.time});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temperatureRepository = ref.watch(temperatureRepositoryProvider);

    final operatorController = TextEditingController();
    final cojineteSoporteController = TextEditingController();
    final cojineteSuperiorController = TextEditingController();
    final cojineteInferiorController = TextEditingController();
    final soporteBombaController = TextEditingController();

    void saveTemperature() async {
      final timeParse = DateFormat('yyyy-MM-dd').parse(time);
    

      final temperature = Temperature(
        station: station,
        unit: unit,
        date: date,
        time: timeParse,
        operator: operatorController.text,
        cojineteSoporte: double.tryParse(cojineteSoporteController.text) ?? 0.0,
        cojineteSuperior:
            double.tryParse(cojineteSuperiorController.text) ?? 0.0,
        cojineteInferior:
            double.tryParse(cojineteInferiorController.text) ?? 0.0,
        soporteBomba: double.tryParse(soporteBombaController.text) ?? 0.0,
      );

      await temperatureRepository.saveTemperature(temperature);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Temperatura guardada')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [Text('Registrar Temperatura')],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [Text('Estacion # $station'), Text('Unidad # $unit')],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text('Operador $operator'),
                Text('Fecha $date'),
                Text('Hora $time')
              ],
            ),
            const SizedBox(height: 20),
           
            TextFormField(
              controller: cojineteSoporteController,
              decoration: const InputDecoration(labelText: 'Cojinete Soporte'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              controller: cojineteSuperiorController,
              decoration: const InputDecoration(labelText: 'Cojinete Superior'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              controller: cojineteInferiorController,
              decoration: const InputDecoration(labelText: 'Cojinete Inferior'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              controller: soporteBombaController,
              decoration: const InputDecoration(labelText: 'Soporte Bomba'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTemperature,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
