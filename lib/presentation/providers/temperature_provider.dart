import 'package:bombas2/presentation/providers/local_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bombas2/domain/repositories/temperature_repository.dart';
import 'package:bombas2/infrastructure/repositories/temperature_repository_impl.dart';

final temperatureRepositoryProvider = Provider<TemperatureRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return TemperatureRepositoryImpl(localDataSource);
});