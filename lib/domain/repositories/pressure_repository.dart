import 'package:bombas2/domain/entities/pressure.dart';

abstract class PressureRepository {
  Future<void> savePressure(Pressure pressure);
  Future<List<Pressure>> getAllPressures();
  Future<List<String>> getUniquePressureDates();
  Future<List<Pressure>> getPressureDataByDate(String date);
  Future<List<Pressure>> getTemperatureDataByDate(String date);
}
