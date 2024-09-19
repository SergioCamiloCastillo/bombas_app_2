import 'package:flutter/material.dart';
import 'package:bombas2/presentation/providers/pressure_repository_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Para el formateo de fecha y hora
import 'package:bombas2/domain/entities/pressure.dart';

class PressureDataScreen extends ConsumerWidget {
  final String station;
  final String unit;

  const PressureDataScreen({super.key, required this.station, required this.unit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pressureRepository = ref.watch(pressureRepositoryProvider);

    final operatorController = TextEditingController();
    final lubricacionBombaController = TextEditingController();
    final refrigeracionMotorController = TextEditingController();
    final descargaBombaController = TextEditingController();
    final selloMecanicoController = TextEditingController();

    final timeController = TextEditingController();
    final dateController = TextEditingController();

    // Inicializamos la fecha y la hora actuales
    final now = DateTime.now();
    dateController.text = DateFormat('yyyy-MM-dd').format(now);
    timeController.text = DateFormat('HH:mm').format(now);

    // Método para guardar la presión
    void savePressure() async {
      final pressure = Pressure(
        station: station,
        unit: unit,
        date: dateController.text,  // Utilizamos el valor del campo de fecha
        time: DateFormat('HH:mm').parse(timeController.text),  // Parseamos la hora seleccionada
        operator: operatorController.text,
        lubricacionBomba: double.tryParse(lubricacionBombaController.text) ?? 0.0,
        refrigeracionMotor: double.tryParse(refrigeracionMotorController.text) ?? 0.0,
        descargaBomba: double.tryParse(descargaBombaController.text) ?? 0.0,
        selloMecanico: double.tryParse(selloMecanicoController.text) ?? 0.0,
      );

      await pressureRepository.savePressure(pressure);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Presión guardada')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Presión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de Fecha
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Fecha'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              },
            ),
            // Campo de Hora
            TextFormField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Hora'),
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  final now = DateTime.now();
                  final formattedTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                  timeController.text = DateFormat('HH:mm').format(formattedTime);
                }
              },
            ),
            // Otros campos de texto
            TextFormField(
              controller: operatorController,
              decoration: const InputDecoration(labelText: 'Operador'),
            ),
            TextFormField(
              controller: lubricacionBombaController,
              decoration: const InputDecoration(labelText: 'Lubricación Bomba'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              controller: refrigeracionMotorController,
              decoration: const InputDecoration(labelText: 'Refrigeración Motor'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              controller: descargaBombaController,
              decoration: const InputDecoration(labelText: 'Descarga Bomba'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              controller: selloMecanicoController,
              decoration: const InputDecoration(labelText: 'Sello Mecánico'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: savePressure,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}