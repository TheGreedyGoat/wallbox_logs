import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/back_layer/appdata.dart';
import 'package:wallbox_logs/back_layer/asset_file_reader.dart';
import 'package:wallbox_logs/front_layer/widget_tree.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preload();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

Future<void> preload() async {
  await windowManager.ensureInitialized();
  await windowManager.setMinimumSize(Size(1000, 800));

  await WallBoxTransaction.repo.clear();
  await UserMasterData.repo.clear();

  if (WallBoxTransaction.repo.cache.isEmpty) {
    await AssetFileReader.loadFileData(
      'assets/20260414 ACE0398688_Transactions.csv',
      (file) async {
        await WallBoxParser.parseWallBoxFile(file);
      },
    );
  }
  UserMasterData.repo.createOrUpdate(
    UserMasterData(tagID: '050FE8E3210000', prename: 'Bugs', surname: 'Bunny'),
  );
  UserMasterData.repo.createOrUpdate(
    UserMasterData(
      tagID: '0421102A577481',
      prename: 'Alex',
      surname: 'Schertl',
    ),
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
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
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
