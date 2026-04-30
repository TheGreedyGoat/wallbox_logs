import 'package:flutter/material.dart';
import 'package:wallbox_logs/main.dart';
import 'package:wallbox_logs/mid_layer/data/file_data.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';

import 'wallbox_log_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print(DateTime.parse(DateTime.now().toString()));
  await clearFiles();
  List<FileData> files = WallboxLogGenerator.generateFiles(
    startDate: DateTime.now(),
    initialPowerLevel: 2500,
    maxDuration: Duration(days: 10),
    numFiles: 5,
  );
  await saveMultiFiles(files);
  for (var file in files) {
    Parser.parseWallBoxFile2(file);
  }

  runApp(MyApp());
}

void callback(FileData data) {
  Parser.parseWallBoxFile2(data);
}
