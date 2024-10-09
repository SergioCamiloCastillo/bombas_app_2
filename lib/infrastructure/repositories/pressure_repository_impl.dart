import 'package:bombas2/domain/entities/pressure.dart';
import 'package:bombas2/domain/repositories/pressure_repository.dart';
import 'package:bombas2/infrastructure/datasources/local_data_source.dart';

class PressureRepositoryImpl implements PressureRepository {
  final LocalDataSource localDataSource;

  PressureRepositoryImpl(this.localDataSource);

  @override
  Future<void> savePressure(Pressure pressure) async {
    await localDataSource.insertPressure(pressure.toJson());
  }

  @override
  Future<List<Pressure>> getAllPressures() async {
    final pressureMaps = await localDataSource.getAllPressures();
    return pressureMaps
        .map((pressureMap) => Pressure.fromJson(pressureMap))
        .toList();
  }

  @override
  Future<List<String>> getUniquePressureDates() async {
    // Llama al método correspondiente en el LocalDataSource
    return await localDataSource.getUniquePressureDates();
  }

  @override
  Future<List<Pressure>> getPressureDataByDate(String date) async {
    final pressureMaps = await localDataSource.getPressureDataByDate(date);
    return pressureMaps
        .map((pressureMap) => Pressure.fromJson(pressureMap))
        .toList();
  }

  @override
  Future<List<Pressure>> getTemperatureDataByDate(String date) async {
    final pressureMaps = await localDataSource.getTemperatureDataByDate(date);
    return pressureMaps
        .map((pressureMap) => Pressure.fromJson(pressureMap))
        .toList();
  }
}
