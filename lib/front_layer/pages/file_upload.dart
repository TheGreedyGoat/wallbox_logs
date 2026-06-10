import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/widgets/input_field_decoration.dart';
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
                int successful = await WallBoxParser.processFilePickerResult(
                  await FilePicker.pickFiles(
                    dialogTitle: 'Hello',
                    type: FileType.custom,
                    allowMultiple: true,
                    allowedExtensions: ['csv'],
                    lockParentWindow: true,
                  ),
                  (fileName) async {
                    String? newName = await _changeExistingFileNameDialog(
                      context,
                      fileName,
                    );
                    return newName;
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      successful == 0
                          ? 'Datei(en) wurden nicht eingelesen'
                          : '$successful Datei${successful > 1 ? 'en' : ''} erfolgreich eingelesen',
                    ),
                  ),
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
        ],
      ),
    );
  }

  Future<String?> _changeExistingFileNameDialog(
    BuildContext context,
    String fileName,
  ) async => await showDialog<String>(
    context: context,
    builder: (context) {
      TextEditingController controller = TextEditingController(text: fileName);
      return AlertDialog(
        title: Text('Dateiname $fileName existiert bereits.'),
        content: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 200, maxWidth: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                softWrap: true,
                'Achtung! Wird der Name geändert, werden alle Transaktionen eingelesen, selbst wenn sie bereits existieren',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                height: 20,
              ),
              InputFieldDecoration(
                child: TextField(
                  controller: controller,
                ),
              ),
            ],
          ),
        ),

        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text('überspringen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: Text('umbenennen'),
          ),
        ],
      );
    },
  );
}
