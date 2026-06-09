import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wallbox_logs/mid_layer/parser.dart';

/// A Page used to load new WalboxLog files into the app
class FileUpload extends StatefulWidget {
  /// A Page used to load new WalboxLog files into the app
  const FileUpload({super.key});

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  static final borderRadius = Radius.circular(10.0);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300,
            child: GestureDetector(
              onTap: () async {
                await WallBoxParser.processFilePickerResult(
                  await FilePicker.pickFiles(
                    dialogTitle: 'Hello',
                    type: FileType.custom,
                    allowMultiple: true,
                    allowedExtensions: ['csv'],
                    lockParentWindow: true,
                  ),
                  (fileName) async {
                    return await _existingDialog(context, fileName) ?? false;
                  },
                );
                setState(
                  () {},
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.all(borderRadius),
                ),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: borderRadius,
                    dashPattern: const [8, 8],
                    strokeWidth: 5,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file_sharp,
                          size: 50,
                        ),

                        Text(
                          'Dateien hier her ziehen oder klicken zum Hochladen',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          FutureBuilder(
            future: WallBoxParser.existingFileNames,
            builder: (context, asyncSnapshot) {
              return !asyncSnapshot.hasData
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bekannte Dateien:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          for (final name in asyncSnapshot.data!)
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(name),
                              ],
                            ),
                        ],
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> _existingDialog(BuildContext context, String fileName) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Doppelte Datei',
        ),
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Eine Datei mit dem Namen\n'),
              TextSpan(text: '$fileName\n'),
              TextSpan(
                text: 'existiert bereits. Soll sie übersprungen werden?',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('überspringen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('trotzdem einlesen'),
          ),
        ],
      ),
    );
  }
}
