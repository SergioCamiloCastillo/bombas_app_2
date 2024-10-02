import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OperatorScreen extends ConsumerWidget {
  OperatorScreen({super.key});

  final operatorController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    @override
    void initState() {
      final now = DateTime.now();
      dateController.text = DateFormat('yyyy-MM-dd').format(now);
      timeController.text = DateFormat('HH:mm').format(now);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Operador'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: operatorController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del Operador'),
            ),
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
                  dateController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              },
            ),
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
                  timeController.text = pickedTime.format(context);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final operator = operatorController.text;

                if (operator.isNotEmpty) {
                  // Ir a la siguiente pantalla, pasando el nombre del operador, fecha y hora
                  Navigator.pushNamed(
                    context,
                    '/station',
                    arguments: {
                      'operator': operator,
                      'date': dateController.text,
                      'time': timeController.text,
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor ingrese su nombre')),
                  );
                }
              },
              child: const Text('Continuar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/data_review',
                    arguments: {'dataType': 'temperature'});
              },
              child: const Text('Revisar Datos Guardados temperatura'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/data_review',
                    arguments: {'dataType': 'pressure'});
              },
              child: const Text('Revisar Datos Guardados presión'),
            )
          ],
        ),
      ),
    );
  }
}
