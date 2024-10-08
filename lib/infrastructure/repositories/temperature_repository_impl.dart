import 'package:bombas2/domain/entities/temperature.dart';
import 'package:bombas2/domain/repositories/temperature_repository.dart';
import 'package:bombas2/infrastructure/datasources/local_data_source.dart';

class TemperatureRepositoryImpl implements TemperatureRepository {
  final LocalDataSource localDataSource;

  TemperatureRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveTemperature(Temperature temperature) async {
    await localDataSource.insertTemperature(temperature.toJson());
  }

  @override
  Future<List<Temperature>> getAllTemperatures() async {
    final temperatureMaps = await localDataSource.getAllTemperatures();
    return temperatureMaps.map((tempMap) => Temperature.fromJson(tempMap)).toList();
  }
  
  @override
  Future<List<Temperature>> getUniquePressureDates() {
    // TODO: implement getUniquePressureDates
    throw UnimplementedError();
  }
  
  @override
  Future<List<String>> getUniqueTemperatureDates() {
    // TODO: implement getUniqueTemperatureDates
    throw UnimplementedError();
  }
}
