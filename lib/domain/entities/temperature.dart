class Temperature {
  final int station;
  final int unit;
  final String date;
  final DateTime time;
  final String operator;
  final double cojineteSoporte;
  final double cojineteSuperior;
  final double cojineteInferior;
  final double soporteBomba;

  Temperature({
    required this.station,
    required this.unit,
    required this.date,
    required this.time,
    required this.operator,
    required this.cojineteSoporte,
    required this.cojineteSuperior,
    required this.cojineteInferior,
    required this.soporteBomba,
  });

  Map<String, dynamic> toJson() {
    return {
      'station': station,
      'unit': unit,
      'date': date,
      'time': time.toIso8601String(),
      'operator': operator,
      'cojineteSoporte': cojineteSoporte,
      'cojineteSuperior': cojineteSuperior,
      'cojineteInferior': cojineteInferior,
      'soporteBomba': soporteBomba,
    };
  }

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      station: json['station'],
      unit: json['unit'],
      date: json['date'],
      time: DateTime.parse(json['time']),
      operator: json['operator'],
      cojineteSoporte: json['cojineteSoporte'],
      cojineteSuperior: json['cojineteSuperior'],
      cojineteInferior: json['cojineteInferior'],
      soporteBomba: json['soporteBomba'],
    );
  }
}