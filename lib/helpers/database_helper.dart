import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bombas2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pressures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        station TEXT,
        unit TEXT,
        date TEXT,
        time TEXT,
        operator TEXT,
        lubricacionBomba REAL,
        refrigeracionMotor REAL,
        descargaBomba REAL,
        selloMecanico REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE temperatures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        station TEXT,
        unit TEXT,
        date TEXT,
        time TEXT,
        operator TEXT,
        cojineteSoporte REAL,
        cojineteSuperior REAL,
        cojineteInferior REAL,
        soporteBomba REAL
      )
    ''');
  }
}

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}
