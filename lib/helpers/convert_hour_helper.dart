String convertTo24HourFormat(String time12h) {
  // Separar la hora y AM/PM
  List<String> timeParts = time12h.split(' ');
  String hourMinute = timeParts[0]; // 2:00
  String amPm = timeParts[1].toLowerCase(); // pm o am

  // Dividir hora y minutos
  List<String> hourMinuteParts = hourMinute.split(':');
  int hour = int.parse(hourMinuteParts[0]);
  String minutes = hourMinuteParts[1];

  // Si es "PM" y la hora no es 12, sumar 12 para convertirlo a formato de 24 horas
  if (amPm == 'pm' && hour != 12) {
    hour += 12;
  }
  // Si es "AM" y la hora es 12 (es medianoche), ajustarla a 0
  if (amPm == 'am' && hour == 12) {
    hour = 0;
  }

  // Retornar la hora en formato HH:mm
  return '${hour.toString().padLeft(2, '0')}:$minutes';
}
