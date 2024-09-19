import 'package:bombas2/domain/entities/temperature.dart';
import 'package:bombas2/domain/exceptions/validation_exception.dart';
import 'package:bombas2/domain/repositories/temperature_repository.dart';

class SaveTemperatureUseCase {
  final TemperatureRepository repository;

  SaveTemperatureUseCase(this.repository);
  Future<void> execute(Temperature temperature) {
    _validateTemperature(temperature);
    return repository.saveTemperature(temperature);
  }

  void _validateTemperature(Temperature temperature) {
    final double cojineteSoporte = temperature.cojineteSoporte ?? -1;
    final double cojineteSuperior = temperature.cojineteSuperior ?? -1;
    final double cojineteInferior = temperature.cojineteInferior ?? -1;
    final double soporteBomba = temperature.soporteBomba ?? -1;

    if (cojineteSoporte < -40 ||
        cojineteSoporte > 100 ||
        cojineteSuperior < -40 ||
        cojineteSuperior > 100 ||
        cojineteInferior < -40 ||
        cojineteInferior > 100 ||
        soporteBomba < -40 ||
        soporteBomba > 100) {
      throw ValidationException(
          'Las temperaturas deben estar entre -40°C y 100°C');
    }
  }
}
