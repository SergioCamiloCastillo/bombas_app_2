import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:url_launcher/url_launcher.dart';

class GenerateExcelScreen extends StatelessWidget {
  final String date;

  const GenerateExcelScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Excel'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Solicitar permisos de almacenamiento
            await requestStoragePermission();

            // Obtener los datos de presión y temperatura
            List<Map<String, dynamic>> pressureData =
                await getPressureData(date);
            List<Map<String, dynamic>> temperatureData =
                await getTemperatureData(date);

            // Generar el archivo Excel
            await generateExcel(pressureData, temperatureData, date, context);
          },
          child: const Text('Generar Excel'),
        ),
      ),
    );
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> generateExcel(
      List<Map<String, dynamic>> pressureData,
      List<Map<String, dynamic>> temperatureData,
      String date,
      BuildContext context) async {
    // Crear un nuevo libro de Excel
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Control Diario';

    // 1. Encabezados
    List<String> hours =
        List.generate(25, (index) => '$index:00'); // Horas de 0:00 a 24:00

    // Aplicar formato de la cabecera (negrita, color de fondo y bordes)
    var headerCellStyle = workbook.styles.add('headerStyle');
    headerCellStyle.bold = true;
    headerCellStyle.backColor = '#d8d8d8'; // Color de fondo
    headerCellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
    headerCellStyle.borders.all.color = '#000000'; // Borde negro
    headerCellStyle.hAlign = xlsio.HAlignType.center; // Centrar horizontalmente
    headerCellStyle.vAlign = xlsio.VAlignType.center; // Centrar verticalmente

    // 2. Unidades
    List<String> units = [
      'Unidad 1',
      'Unidad 2',
      'Unidad 3',
      'Unidad 4',
      'Unidad 5',
      'Unidad 6'
    ];

    // Encabezados de datos
    List<String> dataHeaders1 = [
      'Temperatura Motor (°C)', // Encabezados de Temperatura y Presión
      'Temperatura Motor (°C)',
      'Temperatura Motor (°C)',
      'Temperatura Motor (°C)',
      'Presión (psi)',
      'Presión (psi)',
      'Presión (psi)',
    ];
    List<String> dataHeaders2 = [
      'Cojinete Soporte',
      'Cojinete Superior',
      'Cojinete Inferior',
      'Soporte Bomba',
      'Lubricación Bomba',
      'Refrigeración Motor',
      'Descarga Bomba',
    ];

    int startRow = 2; // Comenzar a escribir las unidades desde la fila 2
    for (int i = 0; i < units.length; i++) {
      // Escribir encabezados de "Item" y "Hora"
      sheet.getRangeByIndex(startRow + i * 8, 1).setText('Item');
      sheet.getRangeByIndex(startRow + i * 8, 1).cellStyle = headerCellStyle;

      // Fusionar las celdas "Hora" con la siguiente celda
      sheet.getRangeByIndex(startRow + i * 8, 2, startRow + i * 8, 3).merge();
      var horaCell = sheet.getRangeByIndex(startRow + i * 8, 2);
      horaCell.setText('Hora');
      horaCell.cellStyle = headerCellStyle;

      // Centrar horizontalmente y verticalmente el texto "Hora"
      horaCell.cellStyle.hAlign = xlsio.HAlignType.center;
      horaCell.cellStyle.vAlign = xlsio.VAlignType.center;

      // Escribir horas en la fila correspondiente
      for (int hour = 0; hour < 25; hour++) {
        var hourCell = sheet.getRangeByIndex(startRow + i * 8, hour + 4);
        hourCell.setText(hours[hour]);
        hourCell.cellStyle = headerCellStyle;
      }

      // Colocar encabezados de datos justo debajo de "Hora"
      for (int j = 0; j < dataHeaders1.length; j++) {
        var tempCell = sheet.getRangeByIndex(startRow + i * 8 + 1 + j, 2);
        tempCell.setText(dataHeaders1[j]);
        tempCell.cellStyle.hAlign = xlsio.HAlignType.center; // Centrar
        tempCell.cellStyle.vAlign = xlsio.VAlignType.center;
      }

      // Colocar encabezados de cojinetes en la tercera columna
      for (int j = 0; j < dataHeaders2.length; j++) {
        var cojineteCell = sheet.getRangeByIndex(startRow + i * 8 + 1 + j, 3);
        cojineteCell.setText(dataHeaders2[j]);
        cojineteCell.cellStyle.hAlign = xlsio.HAlignType.center; // Centrar
        cojineteCell.cellStyle.vAlign = xlsio.VAlignType.center;
      }

      // Fusionar celdas de "Temperatura Motor (°C)"
      sheet
          .getRangeByIndex(startRow + i * 8 + 1, 2, startRow + i * 8 + 4, 2)
          .merge();
      var mergedTempCell = sheet.getRangeByIndex(startRow + i * 8 + 1, 2);
      mergedTempCell.setText('Temperatura Motor (°C)');
      mergedTempCell.cellStyle.hAlign = xlsio.HAlignType.center; // Centrar
      mergedTempCell.cellStyle.vAlign = xlsio.VAlignType.center;

      // Fusionar celdas de "Unidad"
      sheet
          .getRangeByIndex(startRow + i * 8 + 1, 1, startRow + i * 8 + 7, 1)
          .merge();
      var mergedUnitCell = sheet.getRangeByIndex(startRow + i * 8 + 1, 1);
      mergedUnitCell.setText(units[i]);

      // Aplicar estilo a la celda de la unidad
      mergedUnitCell.cellStyle.backColor = '#d8d8d8'; // Color de fondo
      mergedUnitCell.cellStyle.bold = true; // Negrita
      mergedUnitCell.cellStyle.hAlign = xlsio.HAlignType.center; // Centrar
      mergedUnitCell.cellStyle.vAlign =
          xlsio.VAlignType.center; // Centrar verticalmente
      mergedUnitCell.cellStyle.rotation = 90; // Rotar texto verticalmente

      // Aplicar bordes y centrado a todas las celdas de datos
      for (int row = startRow + i * 8 + 1;
          row <= startRow + i * 8 + dataHeaders2.length;
          row++) {
        for (int col = 1; col <= 28; col++) {
          var dataCell = sheet.getRangeByIndex(row, col);
          dataCell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
          dataCell.cellStyle.borders.all.color = '#000000'; // Borde negro
          dataCell.cellStyle.hAlign =
              xlsio.HAlignType.center; // Centrar horizontalmente
          dataCell.cellStyle.vAlign =
              xlsio.VAlignType.center; // Centrar verticalmente
        }
      }

      // Rellenar los datos (ejemplo)
      for (int hour = 0; hour < 25; hour++) {
        // Para cada hora, colocar valores de presión y temperatura
        if (i < pressureData.length && i < temperatureData.length) {
          final pressureValue = (pressureData[i]['presion'] ?? 0) as int;
          final temperatureValue =
              (temperatureData[i]['temperatura'] ?? 0) as int;

          // Colocar valores de temperatura y presión en las columnas correspondientes
          sheet
              .getRangeByIndex(startRow + i * 8 + 1, hour + 4)
              .setNumber(temperatureValue.toDouble());
          sheet
              .getRangeByIndex(startRow + i * 8 + 2, hour + 4)
              .setNumber(pressureValue.toDouble());
          sheet
              .getRangeByIndex(startRow + i * 8 + 3, hour + 4)
              .setNumber(pressureValue.toDouble());
          sheet
              .getRangeByIndex(startRow + i * 8 + 4, hour + 4)
              .setNumber(pressureValue.toDouble());
        }
      }
    }

    // Guardar el archivo Excel
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final directory = await getExternalStorageDirectory();
    const downloadPath = '/storage/emulated/0/Download';
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath =
        '$downloadPath/control_diario_estacion_bombeo_$date$timestamp.xlsx';
    final File file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    // Verificar si el archivo fue creado exitosamente
    if (await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Excel guardado en: $filePath'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Abrir',
            onPressed: () async {
              try {
                final Uri uri = Uri.parse(
                    'content://com.example.bombas2.fileprovider/external_files/Download/control_diario_estacion_bombeo_$date$timestamp.xlsx');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  throw 'No se puede abrir el archivo en: $filePath';
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar el archivo.')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getPressureData(String date) async {
    return [
      {
        'time': '0:00',
        'cojineteSoporte': 50,
        'cojineteSuperior': 55,
        'cojineteInferior': 48,
        'presion': 100,
        'lubricacionBomba': 25,
        'refrigeracionMotor': 30,
        'descargaBomba': 80,
        'selloMecanico': 0.5,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> getTemperatureData(String date) async {
    return [
      {
        'time': '0:00',
        'cojineteSoporte': 60,
        'cojineteSuperior': 65,
        'cojineteInferior': 58,
        'temperatura': 70,
        'presion': 90,
        'descargaBomba': 75,
      },
    ];
  }
}
