class Pressure {
  final int station;
  final int unit;
  final String date;
  final DateTime time;
  final String operator;
  final double lubricacionBomba;
  final double refrigeracionMotor;
  final double descargaBomba;
  final double selloMecanico; // Cambiado a double

  Pressure({
    required this.station,
    required this.unit,
    required this.date,
    required this.time,
    required this.operator,
    required this.lubricacionBomba,
    required this.refrigeracionMotor,
    required this.descargaBomba,
    required this.selloMecanico,
  });

  Map<String, dynamic> toJson() {
    return {
      'station': station,
      'unit': unit,
      'date': date,
      'time': time.toIso8601String(),
      'operator': operator,
      'lubricacionBomba': lubricacionBomba,
      'refrigeracionMotor': refrigeracionMotor,
      'descargaBomba': descargaBomba,
      'selloMecanico': selloMecanico, // Guardado como double
    };
  }

  factory Pressure.fromJson(Map<String, dynamic> json) {
    return Pressure(
      station: json['station'],
      unit: json['unit'],
      date: json['date'],
      time: DateTime.parse(json['time']),
      operator: json['operator'],
      lubricacionBomba: json['lubricacionBomba'],
      refrigeracionMotor: json['refrigeracionMotor'],
      descargaBomba: json['descargaBomba'],
      selloMecanico: json['selloMecanico'], // Parseado como double
    );
  }
}