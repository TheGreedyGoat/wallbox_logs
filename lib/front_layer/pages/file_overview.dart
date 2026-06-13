import 'package:flutter/material.dart';
import 'package:wallbox_logs/mid_layer/data/log_file_data.dart';

class FileOverview extends StatelessWidget {
  const FileOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = LogFileData.logs;
    return ListView(
      children: [
        SizedBox(
          width: 200,
          child: OutlinedButton(
            onPressed: () async => await LogFileData.openDirectory(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.folder_open_sharp), Text('Ordner öffnen')],
            ),
          ),
        ),
        ...logs.map((e) {
          return ListTile(title: Text(e.fullName));
        }),
      ],
    );
  }
}
