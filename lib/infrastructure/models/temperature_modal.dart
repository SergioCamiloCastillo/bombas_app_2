import 'package:bombas2/domain/entities/temperature.dart';

class TemperatureModel extends Temperature {
  TemperatureModel({
    required super.station,
    required super.unit,
    required super.date,
    required super.time,
    required super.operator,
    required super.cojineteSoporte,
    required super.cojineteSuperior,
    required super.cojineteInferior,
    required super.soporteBomba,
  });

  factory TemperatureModel.fromJson(Map<String, dynamic> json) {
    return TemperatureModel(
      station: json['station'],
      unit: json['unit'],
      date: json['date'],
      time: json['time'],
      operator: json['operator'],
      cojineteSoporte: json['cojineteSoporte'],
      cojineteSuperior: json['cojineteSuperior'],
      cojineteInferior: json['cojineteInferior'],
      soporteBomba: json['soporteBomba'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'station': station,
      'unit': unit,
      'date': date,
      'time': time,
      'operator': operator,
      'cojineteSoporte': cojineteSoporte,
      'cojineteSuperior': cojineteSuperior,
      'cojineteInferior': cojineteInferior,
      'soporteBomba': soporteBomba,
    };
  }
}
