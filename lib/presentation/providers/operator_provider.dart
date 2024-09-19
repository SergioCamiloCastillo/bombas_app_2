import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para almacenar el nombre del operador
final operatorProvider = StateProvider<String>((ref) => '');