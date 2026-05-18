import 'package:flutter/material.dart';
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

  WallBoxTransaction.repo.clear();
  UserMasterData.repo.clear();
  await AssetFileReader.loadAllInFolder(
    'assets/generated',
    (p0) {
      print(p0.fullName);
      if (p0.extension == 'csv') {
        WallBoxParser.parseWallBoxFile(p0);
      }
    },
  );
  // await AssetFileReader.loadFileData(
  //   'assets/20260414 ACE0398688_Transactions.csv',
  //   (data) {
  //     WallBoxParser.parseWallBoxFile(data);
  //   },
  // );

  UserMasterData.repo.createOrUpdate(
    UserMasterData(
      prename: 'Alex',
      surname: null,
      tagID: 'ALEX000000',
      company: 'cdemy',
    ),
  );
  UserMasterData.repo.createOrUpdate(
    UserMasterData(
      prename: 'Yacup',
      surname: 'Acar',
      tagID: 'YACUP9999',
      company: 'cdemy',
    ),
  );

  UserMasterData.repo.createOrUpdate(
    UserMasterData(tagID: 'ANDREAS000', prename: 'Andreas', surname: 'Höfer'),
  );
  runApp(
    MyApp(),
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
