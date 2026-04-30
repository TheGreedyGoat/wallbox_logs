import 'package:flutter/material.dart';
import 'package:wallbox_logs/back_layer/asset_file_reader.dart';
import 'package:wallbox_logs/front_layer/widget_tree.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AssetFileReader.loadFileData(
    'assets/20260430 ACE0398688_transactions_generated_0.csv',
    (data) {
      Parser.parseWallBoxFile2(data);
    },
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),

      home: WidgetTree(),
    );
  }
}
