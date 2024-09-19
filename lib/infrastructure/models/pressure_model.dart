import 'package:bombas2/domain/entities/pressure.dart';

class PressureModel extends Pressure {
  PressureModel({
    required super.station,
    required super.unit,
    required super.date,
    required super.time,
    required super.operator,
    required super.lubricacionBomba,
    required super.refrigeracionMotor,
    required super.descargaBomba,
    required super.selloMecanico,
  });

  factory PressureModel.fromJson(Map<String, dynamic> json) {
    return PressureModel(
      station: json['station'],
      unit: json['unit'],
      date: json['date'],
      time: json['time'],
      operator: json['operator'],
      lubricacionBomba: json['lubricacionBomba'],
      refrigeracionMotor: json['refrigeracionMotor'],
      descargaBomba: json['descargaBomba'],
      selloMecanico: json['selloMecanico'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'station': station,
      'unit': unit,
      'date': date,
      'time': time,
      'operator': operator,
      'lubricacionBomba': lubricacionBomba,
      'refrigeracionMotor': refrigeracionMotor,
      'descargaBomba': descargaBomba,
      'selloMecanico': selloMecanico,
    };
  }
}
