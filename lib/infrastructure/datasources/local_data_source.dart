import 'package:bombas2/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource {
  Future<void> insertPressure(Map<String, dynamic> pressure);
  Future<void> insertTemperature(Map<String, dynamic> temperature);
  Future<List<Map<String, dynamic>>> getAllPressures();
  Future<List<Map<String, dynamic>>> getAllTemperatures();
  Future<List<String>> getUniquePressureDates();
  Future<List<String>> getUniqueTemperatureDates();
  Future<Database> get database;
}

class LocalDataSourceImpl implements LocalDataSource {
  final DatabaseHelper databaseHelper;

  LocalDataSourceImpl(this.databaseHelper);

  @override
  Future<void> insertPressure(Map<String, dynamic> pressure) async {
    final db = await databaseHelper.database;
    await db.insert('pressures', pressure);
  }

  @override
  Future<void> insertTemperature(Map<String, dynamic> temperature) async {
    final db = await databaseHelper.database;
    await db.insert('temperatures', temperature);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllPressures() async {
    final db = await databaseHelper.database;
    return await db.query('pressures');
  }

  @override
  Future<List<Map<String, dynamic>>> getAllTemperatures() async {
    final db = await databaseHelper.database;
    return await db.query('temperatures');
  }
@override
  Future<List<String>> getUniquePressureDates() async {
    final db = await databaseHelper.database;
    final result = await db.rawQuery('SELECT DISTINCT date FROM pressures');
    return result.map((e) => e['date'] as String).toList();
  }
@override
  Future<List<String>> getUniqueTemperatureDates() async {
    final db = await databaseHelper.database;
    final result = await db.rawQuery('SELECT DISTINCT date FROM temperatures');
    return result.map((e) => e['date'] as String).toList();
  }

  @override
  Future<Database> get database => databaseHelper.database;
}
