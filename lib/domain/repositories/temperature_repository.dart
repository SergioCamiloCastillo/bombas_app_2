import 'package:bombas2/domain/entities/temperature.dart';

abstract class TemperatureRepository {
  Future<void> saveTemperature(Temperature temperature);
  Future<List<Temperature>> getAllTemperatures();
}
