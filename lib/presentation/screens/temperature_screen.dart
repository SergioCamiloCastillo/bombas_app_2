import 'package:flutter/material.dart';
import 'package:bombas2/presentation/providers/temperature_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bombas2/domain/entities/temperature.dart';

class TemperatureScreen extends ConsumerStatefulWidget {
  final int station;
  final int unit;
  final String operator;
  final String date;
  final String time;

  const TemperatureScreen({
    super.key,
    required this.station,
    required this.unit,
    required this.operator,
    required this.date,
    required this.time,
  });

  @override
  _TemperatureScreenState createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends ConsumerState<TemperatureScreen> {
  final _formKey = GlobalKey<FormState>();

  final cojineteSoporteController = TextEditingController();
  final cojineteSuperiorController = TextEditingController();
  final cojineteInferiorController = TextEditingController();
  final soporteBombaController = TextEditingController();

  @override
  void dispose() {
    // Limpiar los controladores al eliminar el widget
    cojineteSoporteController.dispose();
    cojineteSuperiorController.dispose();
    cojineteInferiorController.dispose();
    soporteBombaController.dispose();
    super.dispose();
  }

  // Método para guardar la temperatura
  void saveTemperature() {
    // Validar el formulario al presionar el botón
    if (_formKey.currentState!.validate()) {
      final temperature = Temperature(
        station: widget.station,
        unit: widget.unit,
        date: widget.date,
        time: widget.time,
        operator: widget.operator,
        cojineteSoporte: double.tryParse(cojineteSoporteController.text) ?? 0.0,
        cojineteSuperior:
            double.tryParse(cojineteSuperiorController.text) ?? 0.0,
        cojineteInferior:
            double.tryParse(cojineteInferiorController.text) ?? 0.0,
        soporteBomba: double.tryParse(soporteBombaController.text) ?? 0.0,
      );

      // Guardar la temperatura
      ref.read(temperatureRepositoryProvider).saveTemperature(temperature).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Temperatura guardada')));
        _formKey.currentState!.reset(); // Limpiar los campos después de guardar
        Navigator.pushReplacementNamed(context, '/');
      });
    } else {
      // Si el formulario no es válido, mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, complete todos los campos obligatorios.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Temperatura'),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: cojineteSoporteController,
                  decoration: const InputDecoration(labelText: 'Cojinete Soporte'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido'; // Mensaje de error
                    }
                    return null; // Si el campo es válido, retornamos null
                  },
                ),
                TextFormField(
                  controller: cojineteSuperiorController,
                  decoration: const InputDecoration(labelText: 'Cojinete Superior'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: cojineteInferiorController,
                  decoration: const InputDecoration(labelText: 'Cojinete Inferior'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: soporteBombaController,
                  decoration: const InputDecoration(labelText: 'Soporte Bomba'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveTemperature,
                  child: const Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/data_review', arguments: {'dataType': 'temperature'});
                  },
                  child: const Text('Revisar Datos Guardados temperatura'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/data_review', arguments: {'dataType': 'pressure'});
                  },
                  child: const Text('Revisar Datos Guardados presión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}