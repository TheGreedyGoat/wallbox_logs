import 'package:flutter/material.dart';
import 'package:wallbox_logs/back_layer/asset_file_reader.dart';
import 'package:wallbox_logs/mid_layer/data/user_profile.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AssetFileReader.loadFileData(
    'assets/20260414 ACE0398688_Transactions copy.csv',
    (data) {
      Parser.parseWallBoxFile(data);
    },
  );

  runApp(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text('UserID: [id]'),
                subtitle: Text('27 kWh'),
              ),
              for (var profile in UserProfile.profiles)
                ListTile(
                  title: Text(
                    profile.id.toString(),
                  ),
                  subtitle: Text(
                    'Totaler Verbrauch: ${profile.totalConsumption.toStringAsFixed(3)} kWh',
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
