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
    cojineteSoporteController.dispose();
    cojineteSuperiorController.dispose();
    cojineteInferiorController.dispose();
    soporteBombaController.dispose();
    super.dispose();
  }

  void saveTemperature() {
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

      ref
          .read(temperatureRepositoryProvider)
          .saveTemperature(temperature)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Temperatura guardada')));
        _formKey.currentState!.reset();
        Navigator.pushReplacementNamed(context, '/');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Por favor, complete todos los campos obligatorios.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F9FD),
        title: const Text(
          'Registrar Temperatura',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card que contiene dos columnas
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Columna izquierda: Estación y Unidad
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                icon: Icons.build, // Ícono para Estación
                                label: 'Estación: ',
                                value: '# ${widget.station}',
                              ),
                              const SizedBox(height: 10),
                              _buildInfoRow(
                                icon: Icons
                                    .precision_manufacturing, // Ícono para Unidad
                                label: 'Unidad: ',
                                value: '# ${widget.unit}',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                icon: Icons.person,
                                label: '',
                                value: widget.operator,
                              ),
                              const SizedBox(height: 10),
                              _buildInfoRow(
                                icon: Icons.calendar_today,
                                label: '',
                                value: widget.date,
                              ),
                              const SizedBox(height: 10),
                              _buildInfoRow(
                                icon: Icons.access_time,
                                label: '',
                                value: widget.time,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5), // Separación entre columnas

                        // Columna derecha: Operador, Fecha y Hora
                      ],
                    ),
                  ),
                ),

                const Divider(height: 30, thickness: 1), // Separador visual

                // Campos de temperatura
                _buildTextField(
                  label: 'Cojinete Soporte',
                  controller: cojineteSoporteController,
                ),
                _buildTextField(
                  label: 'Cojinete Superior',
                  controller: cojineteSuperiorController,
                ),
                _buildTextField(
                  label: 'Cojinete Inferior',
                  controller: cojineteInferiorController,
                ),
                _buildTextField(
                  label: 'Soporte Bomba',
                  controller: soporteBombaController,
                ),
                const SizedBox(height: 20),

                // Botón para guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveTemperature,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir un TextFormField con estilo moderno
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: const Color(0xFFF0F9FD),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          return null;
        },
      ),
    );
  }

  // Método para construir una fila de información con ícono, etiqueta y valor
  Widget _buildInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1E3A8A)),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
