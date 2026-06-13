import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/back_layer/appdata.dart';
import 'package:wallbox_logs/front_layer/widget_tree.dart';
import 'package:wallbox_logs/mid_layer/data/log_file_data.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

/// ...
Future<void> preload() async {
  await AppData.load();
  await UserMasterData.repo.preload();
  await LogFileData.preload();
  await LogFileData.clear();
  await WallBoxTransaction.repo.preload();
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
          seedColor: Color.fromRGBO(200, 103, 24, 1),
          brightness: Brightness.dark,
        ),
      ),
      home: WidgetTree(),
    );
  }
}
