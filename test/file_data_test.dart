import 'package:flutter/material.dart';
import 'package:wallbox_logs/back_layer/asset_file_reader.dart';
import 'package:wallbox_logs/mid_layer/data/file_data.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AssetFileReader.loadFileData(
    'assets/20260414 ACE0398688_Transactions copy.csv',
    callback,
  );
}

void callback(FileData data) {
  Parser.parseWallBoxFile(data);
}
