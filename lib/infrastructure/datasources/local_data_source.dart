import 'package:bombas2/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource {
  Future<void> insertPressure(Map<String, dynamic> pressure);
  Future<void> insertTemperature(Map<String, dynamic> temperature);
  Future<List<Map<String, dynamic>>> getAllPressures();
  Future<List<Map<String, dynamic>>> getAllTemperatures();
  Future<List<String>> getUniquePressureDates();
  Future<List<String>> getUniqueTemperatureDates();
  Future<List<Map<String, dynamic>>> getPressureDataByDate(String date);
  Future<List<Map<String, dynamic>>> getTemperatureDataByDate(String date);
  Future<List<Map<String, Object?>>> getOperatorForTimeAndDate(String date, String time12h);
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
  Future<List<Map<String, dynamic>>> getPressureDataByDate(String date) async {
    final db = await databaseHelper.database;
    return await db.query('pressures', where: 'date = ?', whereArgs: [date]);
  }

  @override
  Future<List<Map<String, dynamic>>> getTemperatureDataByDate(
      String date) async {
    final db = await databaseHelper.database;
    return await db.query('temperatures', where: 'date = ?', whereArgs: [date]);
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
  Future<List<Map<String, Object?>>> getOperatorForTimeAndDate(String date, String time12h) async {
    print('llega quiii');
    final db = await databaseHelper.database;
    final pressureResult = await db.rawQuery('''
    SELECT operator, time FROM pressures WHERE date = ?
  ''', [date]);

    final temperatureResult = await db.rawQuery('''
    SELECT operator, time FROM temperatures WHERE date = ?
  ''', [date]);
  return [...pressureResult, ...temperatureResult];
  }

  @override
  Future<Database> get database => databaseHelper.database;
}

int getTurnForTime(String time12h) {
  // Convertir a formato de 24 horas
  List<String> firstShifts = [
    '0:00 am',
    '1:00 am',
    '2:00 am',
    '3:00 am',
    '4:00 am',
    '5:00 am',
    '6:00 am',
    '7:00 am'
  ];
  List<String> secondShifts = [
    '8:00 am',
    '9:00 am',
    '10:00 am',
    '11:00 am',
    '12:00 pm',
    '1:00 pm',
    '2:00 pm',
    '3:00 pm'
  ];
  List<String> thirdShifts = [
    '4:00 pm',
    '5:00 pm',
    '6:00 pm',
    '7:00 pm',
    '8:00 pm',
    '9:00 pm',
    '10:00 pm',
    '11:00 pm'
  ];

  if (firstShifts.contains(time12h)) {
    return 1; // Turno 1: 00:00 - 06:59
  } else if (secondShifts.contains(time12h)) {
    return 2; // Turno 2: 07:00 - 14:59
  } else if (thirdShifts.contains(time12h)) {
    return 3; // Turno 3: 15:00 - 23:59
  } else {
    return 0; // No se encontró el turno
  }
}

String convertTo24HourFormat(String time12h) {
  final timeParts = time12h.split(' ');
  final hourMinute = timeParts[0].split(':');
  int hour = int.parse(hourMinute[0]);
  final int minute = int.parse(hourMinute[1]);
  final period = timeParts[1].toUpperCase(); // AM o PM

  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0; // Caso especial para medianoche
  }

  // Devolver la hora en formato HH:MM de 24 horas
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
