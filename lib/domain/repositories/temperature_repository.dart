import 'package:bombas2/domain/entities/temperature.dart';

abstract class TemperatureRepository {
  Future<void> saveTemperature(Temperature temperature);
  Future<List<Temperature>> getAllTemperatures();
  Future<List<String>> getUniqueTemperatureDates();
  Future<List<Temperature>> getUniquePressureDates();
  Future<String> getOperatorForTimeAndDate(String date, String time12h);
}
