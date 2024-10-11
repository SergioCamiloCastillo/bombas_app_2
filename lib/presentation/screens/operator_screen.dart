import 'package:bombas2/presentation/providers/local_data_source_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OperatorScreen extends ConsumerStatefulWidget {
  const OperatorScreen({super.key});

  @override
  _OperatorScreenState createState() => _OperatorScreenState();
}

class _OperatorScreenState extends ConsumerState<OperatorScreen> {
  final operatorController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  // Estado que controla si el campo del operador es editable
  bool isOperatorFieldEditable = true;

  // Listas con los horarios por turno
  final List<String> firstShifts = [
    '0:00AM',
    '1:00AM',
    '2:00AM',
    '3:00AM',
    '4:00AM',
    '5:00AM',
    '6:00AM',
    '7:00AM',
  ];
  final List<String> secondShifts = [
    '8:00AM',
    '9:00AM',
    '10:00AM',
    '11:00AM',
    '12:00PM',
    '1:00PM',
    '2:00PM',
    '3:00PM',
  ];
  final List<String> thirdShifts = [
    '4:00PM',
    '5:00PM',
    '6:00PM',
    '7:00PM',
    '8:00PM',
    '9:00PM',
    '10:00PM',
    '11:00PM',
  ];

  // Función para validar operador basado en el turno
  Future<void> validateOperator(
      WidgetRef ref, String date, String time12h) async {
    String shift;

    // Determinar a qué turno pertenece la hora seleccionada
    if (firstShifts.contains(time12h.replaceAll(RegExp(r'\s+'), ''))) {
      shift = 'turno1';
    } else if (secondShifts.contains(time12h.replaceAll(RegExp(r'\s+'), ''))) {
      shift = 'turno2';
    } else if (thirdShifts.contains(time12h.replaceAll(RegExp(r'\s+'), ''))) {
      shift = 'turno3';
    } else {
      shift = 'Turnodesconocido';
    }

    // Verificar si ya existe un operador en esa fecha y turno
    print('mijito=>$time12h');
    print('el shift=>$shift');
    final dataOperators = await ref
        .read(localDataSourceProvider)
        .getOperatorForTimeAndDate(date, time12h);
    List<String> operatorsFound = [];
    bool timeExists = dataOperators.any((operator) {
      print('el operador esss=>$operator');
      String? operatorName = operator['operator']?.toString().trim();
      if (operatorName == null || operatorName.isEmpty) {
        return false; // Si el nombre del operador está vacío, no se considera
      }
      String? time =
          operator['time']?.toString().replaceAll(RegExp(r'\s+'), '');
      print('ellll time=>$time');
      print('el timetime=>$time');
      bool exists = shift == 'turno1'
          ? firstShifts.contains(time)
          : shift == 'turno2'
              ? secondShifts.contains(time)
              : shift == 'turno3'
                  ? thirdShifts.contains(time)
                  : false;

      // Si existe, se agrega el nombre del operador a la lista
      if (exists) {
        print(
          'alcanza a entrar=>${operator['operator']}',
        );
        operatorsFound.add(operator['operator'].toString() ?? '');
      }

      return exists; // Retorna true si existe
    });

    // Imprimir resultados
    if (timeExists && operatorsFound.isNotEmpty) {
      print('Al menos un operador tiene un tiempo en el primer turno.');
      print('Operadores encontrados: ${operatorsFound[0]}');

      // Asignar el operador encontrado al controlador y hacerlo de solo lectura
      operatorController.text = operatorsFound[0];
      operatorController.selection = TextSelection.fromPosition(TextPosition(
          offset:
              operatorController.text.length)); // Colocar el cursor al final

      // Cambiar el estado del campo a no editable
      setState(() {
        isOperatorFieldEditable = false; // Bloquear el campo
      });
    } else {
      operatorController.text = ''; // Limpiar el campo
      setState(() {
        isOperatorFieldEditable = true; // Bloquear el campo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Operador'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo para el operador

            TextFormField(
              controller: dateController,
              decoration: _inputDecoration('Fecha', Icons.date_range),
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

                  // Validar operador si también se ha seleccionado la hora
                  if (timeController.text.isNotEmpty) {
                    print('el ref es=>${timeController.text}');
                    validateOperator(
                        ref,
                        dateController.text,
                        timeController.text.replaceAll(RegExp(r'\s+'), '') ==
                                '12:00AM'
                            ? '0:00 AM'
                            : timeController.text);
                  }
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            // Campo para la hora
            TextFormField(
              controller: timeController,
              decoration: _inputDecoration('Hora', Icons.timelapse),
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  // Redondear la hora seleccionada a la hora más cercana
                  String timeFormatted;
                  if (pickedTime.minute >= 30) {
                    pickedTime =
                        TimeOfDay(hour: pickedTime.hour + 1, minute: 0);
                  } else {
                    pickedTime = TimeOfDay(hour: pickedTime.hour, minute: 0);
                  }

                  // Formatear la hora en formato de 12 horas (am/pm)
                  final now = DateTime.now();
                  final selectedTime = DateTime(now.year, now.month, now.day,
                      pickedTime.hour, pickedTime.minute);
                  timeFormatted = DateFormat.jm().format(
                      selectedTime); // Formato '3:00 PM', '1:00 AM', etc.
                  timeController.text = timeFormatted;

                  // Validar operador si también se ha seleccionado la fecha
                  if (dateController.text.isNotEmpty) {
                    validateOperator(
                        ref,
                        dateController.text,
                        timeController.text.replaceAll(RegExp(r'\s+'), '') ==
                                '12:00AM'
                            ? '0:00 AM'
                            : timeController.text);
                  }
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: operatorController,

              decoration: _inputDecoration('Nombre del Operador', Icons.person),
              readOnly: !isOperatorFieldEditable, // Cambiar según el estado
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
           /*ElevatedButton(
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
            ),*/

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/select_dates');
              },
              child: const Text('Datos de excel'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle:
          const TextStyle(color: Colors.teal), // Color del texto de la etiqueta
      prefixIcon: Icon(icon, color: Colors.teal), // Color del icono
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.teal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
            color: Colors.teal, width: 2.0), // Color cuando está en foco
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
            color: Colors.teal, width: 1.0), // Color cuando está habilitado
      ),
    );
  }
}
