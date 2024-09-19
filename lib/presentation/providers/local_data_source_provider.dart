import 'package:bombas2/helpers/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bombas2/infrastructure/datasources/local_data_source.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final databaseHelper = DatabaseHelper(); // Instancia de DatabaseHelper
  return LocalDataSourceImpl(databaseHelper); // Pasar el databaseHelper al constructor
});