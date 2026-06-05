import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/back_layer/appdata.dart';
import 'package:wallbox_logs/back_layer/asset_file_reader.dart';
import 'package:wallbox_logs/front_layer/widget_tree.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';
import 'package:wallbox_logs/mid_layer/wall_box_parser_2.0.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AssetFileReader.loadFileData(
    'assets/20260414 ACE0398688_Transactions.csv',
    (file) async {
      print(WallBoxLog(file.content));
    },
  );
  // await windowManager.ensureInitialized();
  // await windowManager.setMinimumSize(Size(1500, 800));

  // await preload();
  // runApp(
  //   const ProviderScope(child: MyApp()),
  // );
}

Future<void> preload() async {
  try {
    await UserMasterData.repo.preload();
  } catch (e) {
    UserMasterData.repo.clear();
  }

  try {
    await WallBoxTransaction.repo.preload();
  } catch (e) {
    WallBoxTransaction.repo.clear();
  }

  if (WallBoxTransaction.repo.cache.isEmpty) {
    await AssetFileReader.loadFileData(
      'assets/20260414 ACE0398688_Transactions.csv',
      (file) async {
        await WallBoxParser.parseWallBoxFile(file);
      },
    );
  }

  if (WallBoxTransaction.repo.cache.isEmpty) {}
  for (final transaction in WallBoxTransaction.repo.getAll()) {
    if (transaction.powerUsageWh == 0) {
      WallBoxTransaction.repo.delete(transaction.tagID);
    }
  }
}

/// The apps root
class MyApp extends StatelessWidget {
  /// The apps root
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),

      // darkTheme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      // ),
      home: WidgetTree(),
    );
  }
}
