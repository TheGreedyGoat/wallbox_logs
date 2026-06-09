import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widget_tree.dart';
import 'package:wallbox_logs/mid_layer/services/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/services/user_master/user_master_data.dart';
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

/// ...
Future<void> preload() async {
  UserMasterData.repo.clear();
  WallBoxTransaction.repo.clear();
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
      home: WidgetTree(),
    );
  }
}
