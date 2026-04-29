import 'package:flutter/material.dart';
import 'package:wallbox_logs/back_layer/asset_file_reader.dart';
import 'package:wallbox_logs/front_layer/user_overview_Page/user_overview.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AssetFileReader.loadFileData(
    'assets/20260414 ACE0398688_Transactions copy.csv',
    (data) {
      Parser.parseWallBoxFile2(data);
    },
  );
  // await AssetFileReader.loadFileData(
  //   'assets/20260414 ACE0398688_Transactions.csv',
  //   (data) {
  //     Parser.parseWallBoxFile(data);
  //   },
  // );

  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Overview'),
          backgroundColor: Colors.amber,
        ),
        body: UserOverview(),
      ),
    ),
  );
}
