import 'package:bombas2/domain/repositories/pressure_repository.dart';
import 'package:bombas2/infrastructure/repositories/pressure_repository_impl.dart';
import 'package:bombas2/presentation/providers/local_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pressureRepositoryProvider = Provider<PressureRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return PressureRepositoryImpl(localDataSource);
});
