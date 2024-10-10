import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bombas2/presentation/providers/local_data_source_provider.dart';
import 'package:bombas2/helpers/convert_hour_helper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class SelectDateScreen extends ConsumerWidget {
  const SelectDateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localDataSource = ref.watch(localDataSourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Fecha'),
      ),
      body: FutureBuilder<List<String>>(
        future: Future.wait([
          localDataSource.getUniquePressureDates(),
          localDataSource.getUniqueTemperatureDates(),
        ]).then((results) {
          final List<String> pressureDates = results[0].cast<String>();
          final List<String> temperatureDates = results[1].cast<String>();

          // Unir y convertir a DateTime para ordenar
          final List<DateTime> allDates = <DateTime>{
            ...pressureDates.map((date) => DateTime.parse(date)),
            ...temperatureDates.map((date) => DateTime.parse(date)),
          }.toList();

          // Ordenar de más reciente a más antiguo
          allDates.sort((a, b) => b.compareTo(a));

          // Convertir de nuevo a cadenas en el formato que necesitas
          return allDates
              .map((date) => date.toIso8601String().split('T')[0])
              .toList(); // Cambia el formato si es necesario
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final dates = snapshot.data!;

          if (dates.isEmpty) {
            return const Center(child: Text('No hay fechas disponibles.'));
          }

          return ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              return ListTile(
                title: Text(date),
                onTap: () {
                  // Llama a la función para generar y descargar el Excel
                  _generateAndDownloadExcel(ref, date, context);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _generateAndDownloadExcel(
      WidgetRef ref, String date, BuildContext context) async {
    // Solicitar permisos de almacenamiento
    await requestStoragePermission();

    // Obtener los datos de presión y temperatura
    final localDataSource = ref.read(localDataSourceProvider);
    List<Map<String, dynamic>> pressureData =
        await localDataSource.getPressureDataByDate(date);
    List<Map<String, dynamic>> temperatureData =
        await localDataSource.getTemperatureDataByDate(date);

    // Verificar si los datos están vacíos
    if (pressureData.isEmpty && temperatureData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay datos para la fecha: $date')),
      );
      return;
    }

    // Generar el archivo Excel
    await generateExcel(pressureData, temperatureData, date, context);
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
    final xlsio.Workbook workbook = xlsio.Workbook();
    List<String> unitsName = [
      'Unidad 1',
      'Unidad 2',
      'Unidad 3',
      'Unidad 4',
      'Unidad 5',
      'Unidad 6'
    ];

    List<String> stationsName = [
      'Estación 1',
      'Estación 2',
      'Estación 3',
      'Estación 4',
      'Estación 5',
      'Estación 6'
    ];

    List<String> dataHeaders1 = [
      'Temperatura Motor (°C)',
      'Temperatura Motor (°C)',
      'Temperatura Motor (°C)',
      'Temperatura Motor (°C)',
      'Presión (psi)',
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
      'Sello mecánico',
    ];

    List<String> hours =
        List.generate(25, (index) => '$index:00'); // Horas de 0:00 a 24:00

    for (int stationIndex = 0;
        stationIndex < stationsName.length;
        stationIndex++) {
      final xlsio.Worksheet sheet = workbook.worksheets.add();
      sheet.name = '${stationsName[stationIndex]}_$date';

      // Agregar encabezado
      var headerCell = sheet.getRangeByIndex(2, 5);
      headerCell
          .setText('CONTROL DIARIO ESTACIÓN DE BOMBEO N° ${stationIndex + 1}');
      headerCell.cellStyle.bold = true; // Texto en negrita

      // Agregar fecha
      var dateCell = sheet.getRangeByIndex(3, 5);
      dateCell.setText('FECHA: $date');
      dateCell.cellStyle.bold = true; // Texto en negrita

      // Agregar texto "Unidades de Bombeo" en la parte superior del cuadro
      var titleCell = sheet.getRangeByIndex(4, 1);
      titleCell.setText('Unidades de Bombeo');
      titleCell.cellStyle.bold = true; // Texto en negrita

      var headerCellStyle = workbook.styles.add('headerStyle_$stationIndex');
      headerCellStyle.bold = true;
      headerCellStyle.backColor = '#d8d8d8';
      headerCellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      headerCellStyle.borders.all.color = '#000000';
      headerCellStyle.hAlign = xlsio.HAlignType.center;
      headerCellStyle.vAlign = xlsio.VAlignType.center;

      int startRow = 5;

      for (int i = 0; i < unitsName.length; i++) {
        // Configurar el encabezado de unidad
        sheet.getRangeByIndex(startRow + i * 9, 1).setText('Item');
        sheet.getRangeByIndex(startRow + i * 9, 1).cellStyle = headerCellStyle;

        sheet.getRangeByIndex(startRow + i * 9, 2, startRow + i * 9, 3).merge();
        var horaCell = sheet.getRangeByIndex(startRow + i * 9, 2);
        horaCell.setText('HORA');
        horaCell.cellStyle = headerCellStyle;

        // Llenar horas
        for (int hour = 0; hour < 25; hour++) {
          var hourCell = sheet.getRangeByIndex(startRow + i * 9, hour + 4);
          hourCell.setText(hours[hour]);
          hourCell.cellStyle = headerCellStyle;
        }

        // Rellenar encabezados de datos
        for (int j = 0; j < dataHeaders1.length; j++) {
          var tempCell = sheet.getRangeByIndex(startRow + i * 9 + 1 + j, 2);
          tempCell.setText(dataHeaders1[j]);
          tempCell.cellStyle.hAlign = xlsio.HAlignType.center;
          tempCell.cellStyle.vAlign = xlsio.VAlignType.center;
        }

        for (int j = 0; j < dataHeaders2.length; j++) {
          var cojineteCell = sheet.getRangeByIndex(startRow + i * 9 + 1 + j, 3);
          cojineteCell.setText(dataHeaders2[j]);
          cojineteCell.cellStyle.hAlign = xlsio.HAlignType.center;
          cojineteCell.cellStyle.vAlign = xlsio.VAlignType.center;
        }

        // Configuración de celdas combinadas
        sheet
            .getRangeByIndex(startRow + i * 9 + 1, 2, startRow + i * 9 + 4, 2)
            .merge();
        var mergedTempCell = sheet.getRangeByIndex(startRow + i * 9 + 1, 2);
        mergedTempCell.setText('Temperatura Motor (°C)');
        mergedTempCell.cellStyle.hAlign = xlsio.HAlignType.center;
        mergedTempCell.cellStyle.vAlign = xlsio.VAlignType.center;

        sheet
            .getRangeByIndex(startRow + i * 9 + 1, 1, startRow + i * 9 + 8, 1)
            .merge();
        var mergedUnitCell = sheet.getRangeByIndex(startRow + i * 9 + 1, 1);
        mergedUnitCell.setText(unitsName[i]);
        mergedUnitCell.cellStyle.backColor = '#d8d8d8';
        mergedUnitCell.cellStyle.bold = true;
        mergedUnitCell.cellStyle.hAlign = xlsio.HAlignType.center;
        mergedUnitCell.cellStyle.vAlign = xlsio.VAlignType.center;
        mergedUnitCell.cellStyle.rotation =
            90; // Rotar el texto 90 grados para que sea vertical

        // Establecer bordes para las celdas
        for (int row = startRow + i * 9 + 1;
            row <= startRow + i * 9 + dataHeaders2.length;
            row++) {
          for (int col = 1; col <= 28; col++) {
            var dataCell = sheet.getRangeByIndex(row, col);
            dataCell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
            dataCell.cellStyle.borders.all.color = '#000000';
            dataCell.cellStyle.hAlign = xlsio.HAlignType.center;
            dataCell.cellStyle.vAlign = xlsio.VAlignType.center;
          }
        }

        // Rellenar los datos
        for (int hour = 0; hour < 25; hour++) {
          final String currentHour = hours[hour]; // "0:00", "1:00", etc.

          // Filtrar los datos de temperatura según la estación, unidad y hora convertida
          var filteredTemperatureData = temperatureData.where((entry) {
            print('entry time esss=>${entry['time']}');
            final String entryTime = convertTo24HourFormat(entry['time']);
            print('entry time es=>$entryTime');
            return int.parse(entry['station']) == stationIndex + 1 &&
                int.parse(entry['unit']) == i + 1 &&
                entryTime ==
                    currentHour; // Comparar las horas en formato 24 horas
          }).toList();

          // Filtrar los datos de presión según la estación, unidad y hora convertida
          var filteredPressureData = pressureData.where((entry) {
            final String entryTime = convertTo24HourFormat(entry['time']);
            return int.parse(entry['station']) == stationIndex + 1 &&
                int.parse(entry['unit']) == i + 1 &&
                entryTime ==
                    currentHour; // Comparar las horas en formato 24 horas
          }).toList();
          print('filteredTemperatureData: $filteredTemperatureData');
          // Si hay datos filtrados para esa hora y estación, rellenar el Excel
          if (filteredTemperatureData.isNotEmpty) {
            final tempData = filteredTemperatureData.first;
            sheet
                .getRangeByIndex(startRow + i * 9 + 1, hour + 4)
                .setNumber(tempData['cojineteSoporte'] ?? 0);
            sheet
                .getRangeByIndex(startRow + i * 9 + 2, hour + 4)
                .setNumber(tempData['cojineteSuperior'] ?? 0);
            sheet
                .getRangeByIndex(startRow + i * 9 + 3, hour + 4)
                .setNumber(tempData['cojineteInferior'] ?? 0);
            sheet
                .getRangeByIndex(startRow + i * 9 + 4, hour + 4)
                .setNumber(tempData['soporteBomba'] ?? 0);
          }

          if (filteredPressureData.isNotEmpty) {
            final pressureDataEntry = filteredPressureData.first;
            sheet
                .getRangeByIndex(startRow + i * 9 + 5, hour + 4)
                .setNumber(pressureDataEntry['lubricacionBomba'] ?? 0);
            sheet
                .getRangeByIndex(startRow + i * 9 + 6, hour + 4)
                .setNumber(pressureDataEntry['refrigeracionMotor'] ?? 0);
            sheet
                .getRangeByIndex(startRow + i * 9 + 7, hour + 4)
                .setNumber(pressureDataEntry['descargaBomba'] ?? 0);
            sheet
                .getRangeByIndex(startRow + i * 9 + 8, hour + 4)
                .setNumber(pressureDataEntry['selloMecanico'] ?? 0);
          }
        }
      }
    }

    // Guardar el archivo
    final String path = (await getApplicationDocumentsDirectory()).path;
    const downloadPath = '/storage/emulated/0/Download';
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$downloadPath/Reporte_$date$timestamp.xlsx';
    final File file = File(filePath);
    await file.writeAsBytes(workbook.saveAsStream());

    // Mostrar un diálogo de confirmación de descarga
    _showDownloadDialog(context, filePath);
  }

  // Método para mostrar el diálogo de confirmación de descarga
  void _showDownloadDialog(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Descarga Completa'),
          content: Text('El archivo se ha descargado en:\n$filePath'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
