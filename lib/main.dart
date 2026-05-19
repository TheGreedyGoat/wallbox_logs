import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/back_layer/asset_file_reader.dart';
import 'package:wallbox_logs/front_layer/widget_tree.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.setMinimumSize(Size(800, 800));
  await WallBoxTransaction.repo.preload();
  await UserMasterData.repo.preload();
  // WallBoxTransaction.repo.clear();
  // await AssetFileReader.loadFileData(
  //   'assets/20260414 ACE0398688_Transactions.csv',
  //   (data) {
  //     WallBoxParser.parseWallBoxFile(data);
  //   },
  // );

  // UserMasterData.repo.update(
  //   UserMasterData(
  //     tagID: '050FE8E3210000',
  //     prename: 'Andreas',
  //     surname: 'Höfer',
  //     company: 'cdemy',
  //   ),
  // );
  // UserMasterData.repo.update(
  //   UserMasterData(
  //     tagID: '0421102A577481',
  //     prename: 'Peter',
  //     surname: 'Zwegert',
  //     company: 'Inventarkreisel',
  //   ),
  // );
  runApp(
    const ProviderScope(child: MyApp()),
  );
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
      theme: ThemeData.light(),

      home: WidgetTree(),
    );
  }
}
