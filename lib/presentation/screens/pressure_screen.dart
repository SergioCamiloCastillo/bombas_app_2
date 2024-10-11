import 'package:flutter/material.dart';
import 'package:bombas2/presentation/providers/pressure_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bombas2/domain/entities/pressure.dart';

class PressureDataScreen extends ConsumerStatefulWidget {
  final int station;
  final int unit;
  final String operator;
  final String date;
  final String time;

  const PressureDataScreen({
    super.key,
    required this.station,
    required this.unit,
    required this.operator,
    required this.date,
    required this.time,
  });

  @override
  _PressureDataScreenState createState() => _PressureDataScreenState();
}

class _PressureDataScreenState extends ConsumerState<PressureDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final operatorController = TextEditingController();
  final lubricacionBombaController = TextEditingController();
  final refrigeracionMotorController = TextEditingController();
  final descargaBombaController = TextEditingController();
  final selloMecanicoController = TextEditingController();

  @override
  void dispose() {
    // Limpiar los controladores al eliminar el widget
    operatorController.dispose();
    lubricacionBombaController.dispose();
    refrigeracionMotorController.dispose();
    descargaBombaController.dispose();
    selloMecanicoController.dispose();
    super.dispose();
  }

  // Método para guardar la presión
  void savePressure() {
    if (_formKey.currentState!.validate()) {
      // Crear el objeto Pressure
      final pressure = Pressure(
        station: widget.station,
        unit: widget.unit,
        date: widget.date,
        time: widget.time,
        operator: widget.operator,
        lubricacionBomba:
            double.tryParse(lubricacionBombaController.text) ?? 0.0,
        refrigeracionMotor:
            double.tryParse(refrigeracionMotorController.text) ?? 0.0,
        descargaBomba: double.tryParse(descargaBombaController.text) ?? 0.0,
        selloMecanico: double.tryParse(selloMecanicoController.text) ?? 0.0,
      );

      // Guardar la presión
      ref.read(pressureRepositoryProvider).savePressure(pressure).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Presión guardada')));
        // Limpiar los campos después de guardar
        _formKey.currentState!.reset();
        Navigator.pushReplacementNamed(context, '/');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, complete todos los campos obligatorios.')));
    }
  }

  // Método para navegar a la pantalla de revisión de datos
  void navigateToDataReview(String dataType) {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/data_review', arguments: {'dataType': dataType});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, complete todos los campos obligatorios antes de continuar.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Presión'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Asignamos la clave del formulario
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text('Estación # ${widget.station}'),
                      Text('Unidad # ${widget.unit}'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text('Operador: ${widget.operator}'),
                    Text('Fecha: ${widget.date}'),
                    Text('Hora: ${widget.time}'),
                  ],
                ),
                TextFormField(
                  controller: lubricacionBombaController,
                  decoration:
                      const InputDecoration(labelText: 'Lubricación Bomba'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: refrigeracionMotorController,
                  decoration:
                      const InputDecoration(labelText: 'Refrigeración Motor'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descargaBombaController,
                  decoration:
                      const InputDecoration(labelText: 'Descarga Bomba'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: selloMecanicoController,
                  decoration:
                      const InputDecoration(labelText: 'Sello Mecánico'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: savePressure,
                  child: const Text('Guardar'),
                ),
                /*ElevatedButton(
                  onPressed: () => navigateToDataReview('temperature'),
                  child: const Text('Revisar Datos Guardados temperatura'),
                ),
                ElevatedButton(
                  onPressed: () => navigateToDataReview('pressure'),
                  child: const Text('Revisar Datos Guardados presión'),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}