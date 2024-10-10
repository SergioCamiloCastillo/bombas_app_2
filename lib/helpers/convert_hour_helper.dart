String convertTo24HourFormat(String time12h) {
  // Limpiar la cadena de entrada eliminando espacios en blanco
  time12h = time12h.trim();

  // Separar la hora y AM/PM
  List<String> timeParts = time12h.split(RegExp(r'\s+')); // Usa expresión regular para dividir por cualquier espacio

  // Verificar que timeParts contenga al menos 2 elementos
  if (timeParts.length < 2) {
    throw FormatException('El formato de hora es inválido: $time12h');
  }

  String hourMinute = timeParts[0]; // "6:00"
  String amPm = timeParts[1].toLowerCase(); // "pm" o "am"

  // Dividir hora y minutos
  List<String> hourMinuteParts = hourMinute.split(':');

  // Verificar que hourMinuteParts contenga exactamente 2 elementos
  if (hourMinuteParts.length != 2) {
    throw FormatException('El formato de hora y minutos es inválido: $hourMinute');
  }

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

  // Retornar la hora en formato H:mm (sin cero a la izquierda para horas < 10)
  return '$hour:$minutes';
}