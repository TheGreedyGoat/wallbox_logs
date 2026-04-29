import 'dart:io';
import 'dart:math';

import 'package:wallbox_logs/mid_layer/data/file_data.dart';
import 'package:path/path.dart' as path;

class WallboxLogGenerator {
  static const List<String> ids = ['ALEX000000', 'ANDREAS000', 'YACUP9999'];

  static String _filename(DateTime date) {
    return '${date.year}${date.month < 10 ? '0' : ''}${date.month}${date.day < 10 ? '0' : ''}${date.day} ACE0398688_transactions_generated';
  }

  static List<FileData> generateFiles({
    required DateTime startDate,
    required double initialPowerLevel,
    required Duration maxDuration,
    required int numFiles,
  }) {
    List<FileData> results = List.empty(growable: true);
    List<String> content = _generateFileContent(
      startDate,
      initialPowerLevel,
      maxDuration,
    ).split('\n');

    int firstLine = 0;
    for (int i = 0; i < numFiles - 1; i++) {
      int lastLine = firstLine + (content.length / numFiles).floor();

      results.add(
        _extractSubFile(
          content,
          firstLine,
          lastLine,
          '${_filename(startDate)}_$i',
        ),
      );

      firstLine = lastLine;
    }
    results.add(
      _extractSubFile(
        content,
        firstLine,
        content.length - 1,
        '${_filename(startDate)}_$numFiles',
      ),
    );

    return results;
  }

  static FileData _extractSubFile(
    List<String> content,
    int from,
    int to,
    String filename,
  ) {
    String subContent = content.getRange(from, to).toList().reduce(
      (value, element) {
        return '$value\n$element';
      },
    );

    return FileData.create(
      filename: filename,
      extension: 'csv',
      content: subContent,
    );
  }

  /// generates a file of only completed Charging Processes
  static FileData generateSingleFile(
    DateTime startDate,
    double initialPowerLevel,
    Duration maxDuration,
  ) {
    return FileData.create(
      filename: _filename(startDate),
      extension: 'csv',
      content: _generateFileContent(startDate, initialPowerLevel, maxDuration),
    );
  }

  static String _generateFileContent(
    DateTime startDate,
    double initialPowerLevel,
    Duration maxDuration,
  ) {
    String content = '';
    DateTime endDate = startDate.add(maxDuration);

    DateTime startOfCharging = startDate;
    double currentPowerLevel = initialPowerLevel;
    while (startOfCharging.compareTo(endDate) < 0) {
      final (blockContent, level, stopTime) = generateChargingBlock(
        ids[Random().nextInt(ids.length)],
        currentPowerLevel,
        startOfCharging,
      );

      content += blockContent;
      currentPowerLevel = level;
      startOfCharging = stopTime;
    }
    return content;
  }

  static (String, double, DateTime) generateChargingBlock(
    String id,
    double powerLevel,
    DateTime startTime,
  ) {
    const int maxChargingHours = 5;
    DateTime stopTime = startTime.add(
      Duration(hours: 1 + Random().nextInt(maxChargingHours)),
    );

    String result = '${startLine(startTime, powerLevel, id)}';
    result += mvLine(startTime, powerLevel);
    while (startTime.compareTo(stopTime) < 0) {
      powerLevel += 3;
      startTime = startTime.add(Duration(minutes: 15));
      result += mvLine(startTime, powerLevel);
    }
    result += mvLine(stopTime, powerLevel);
    result += stopLine(stopTime, powerLevel, id);
    return (result, powerLevel, stopTime);
  }

  static String startLine(DateTime date, double powerLevel, String id) {
    return 'txstart2: id 0xffffffffffffffff, socket 1, ${date.toString()} ${powerLevel}kWh $id 3 2 N\n';
  }

  static String mvLine(DateTime date, double powerLevel) {
    return 'mv: socket 1, ${date.toIso8601String()} $powerLevel N\n';
  }

  static String stopLine(DateTime date, double powerLevel, String id) {
    return 'txstop2: id 0xffffffffffffffff, socket 1, ${date.toString()} ${powerLevel}kWh $id 3 2 N\n';
  }
}

Future<void> saveTestFile(FileData fileData) async {
  final projectDir = Directory.current.path;

  final Directory testDir = Directory(
    path.join(projectDir, 'test', 'generated_files'),
  );
  if (!await testDir.exists()) {
    await testDir.create();
  }

  final file = File(path.join(testDir.path, fileData.fullName));
  file.writeAsString(fileData.content);
}
