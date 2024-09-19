
import 'package:bombas2/domain/entities/pressure.dart';
import 'package:bombas2/domain/exceptions/validation_exception.dart';
import 'package:bombas2/domain/repositories/pressure_repository.dart';


class SavePressure {
  final PressureRepository repository;

  SavePressure(this.repository);

  Future<void> execute(Pressure pressure) {
    _validatePressure(pressure);
    return repository.savePressure(pressure);
  }

  void _validatePressure(Pressure pressure) {
    final double lubricacionBomba = pressure.lubricacionBomba ?? -1;
    final double refrigeracionMotor = pressure.refrigeracionMotor ?? -1;
    final double descargaBomba = pressure.descargaBomba ?? -1;
    final double selloMecanico = pressure.selloMecanico ?? -1;

    if (lubricacionBomba < 0 ||
        lubricacionBomba > 300 ||
        refrigeracionMotor < 0 ||
        refrigeracionMotor > 300 ||
        descargaBomba < 0 ||
        descargaBomba > 300 ||
        selloMecanico < 0 ||
        selloMecanico > 300) {
      throw ValidationException('La presión debe estar entre 0 y 300 psi');
    }
  }
}
