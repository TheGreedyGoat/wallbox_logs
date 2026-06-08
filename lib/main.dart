import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/back_layer/appdata.dart';
import 'package:wallbox_logs/back_layer/asset_file_reader.dart';
import 'package:wallbox_logs/front_layer/widget_tree.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';
import 'package:wallbox_logs/mid_layer/parser/wall_box_log.dart';
import 'package:wallbox_logs/utility.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await AssetFileReader.loadFileData(
  //   'assets/20260414 ACE0398688_Transactions.csv',
  //   (file) {
  //     try {
  //       printList(WallBoxLog(file.content).createTransactions());
  //     } catch (e) {
  //       print(e);
  //     }
  //   },
  // );

  await windowManager.setMinimumSize(Size(1500, 800));

  try {
    await preload();
    runApp(
      const ProviderScope(child: MyApp()),
    );
  } catch (e) {
    print(e);
  }
}

Future<void> preload() async {
  try {
    await UserMasterData.repo.preload();
  } catch (e) {
    UserMasterData.repo.clear();
  }

  try {
    await WallBoxTransaction.repo.clear();
  } catch (e) {
    WallBoxTransaction.repo.clear();
  }

  if (WallBoxTransaction.repo.cache.isEmpty) {
    await AssetFileReader.loadFileData(
      'assets/20260414 ACE0398688_Transactions.csv',
      (file) async {
        WallBoxLog(file.content).createTransactions(true);
      },
    );
    await AssetFileReader.loadFileData(
      'assets/part_2.csv',
      (file) async {
        WallBoxLog(file.content).createTransactions(true);
      },
    );
  }

  if (WallBoxTransaction.repo.cache.isEmpty) {}
  for (final transaction in WallBoxTransaction.repo.getAll()) {
    if (transaction.powerUsageWh == 0) {
      WallBoxTransaction.repo.delete(
        transaction.tagID,
        () async {
          return true;
        },
      );
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
          seedColor: Colors.amberAccent,
          brightness: Brightness.dark,
        ),
      ),

      // darkTheme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      // ),
      home: WidgetTree(),
    );
  }
}
