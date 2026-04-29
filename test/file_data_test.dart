import 'package:flutter/material.dart';
import 'package:wallbox_logs/mid_layer/data/file_data.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';

import 'wallbox_log_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<FileData> files = WallboxLogGenerator.generateFiles(
    startDate: DateTime.now(),
    initialPowerLevel: 2500,
    maxDuration: Duration(days: 5),
    numFiles: 3,
  );

  for (var file in files) {
    await saveTestFile(file);
  }
}

void callback(FileData data) {
  Parser.parseWallBoxFile2(data);
}
