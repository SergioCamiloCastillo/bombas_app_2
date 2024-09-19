import 'package:bombas2/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource {
  Future<void> insertPressure(Map<String, dynamic> pressure);
  Future<void> insertTemperature(Map<String, dynamic> temperature);
  Future<List<Map<String, dynamic>>> getAllPressures();
  Future<List<Map<String, dynamic>>> getAllTemperatures();
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
  Future<Database> get database => databaseHelper.database;
}