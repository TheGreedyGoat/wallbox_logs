/// Data struct to store and handle Files
class FileData {
  /// Data struct to store and handle Files
  /// Creates a new FileDataObject and saves it optionally
  FileData.create({
    required this.filename,
    required this.extension,
    this.content = '',
    bool save = true,
  }) {
    if (save) {
      if (!exists(filename, extension)) {
        _saveFile(this);
      } else {
        throw (Exception('File $fullName already exists!'));
      }
    }
  }

  /// Data struct to store and handle Files
  /// factory to create from the full file name
  /// - [fullName] The files name including extension, eg. example.csv
  /// - [content] The contents of the file
  /// - [save] if set to true, the file will be stored in [savedFilesByExtension]
  factory FileData.fromFullName({
    required String fullName,
    String content = '',
    bool save = true,
  }) {
    var split = fullName.split('.');
    assert(
      split.length == 2 && split[0].isNotEmpty && split[1].isNotEmpty,
      'Invalid Filename $fullName',
    );
    return FileData.create(
      filename: split[0],
      extension: split.last,
      content: content,
      save: save,
    );
  }

  /// Runtime storage for FileData sorted by extension
  /// - keys: [String] => the extension, eg. json, csv, md
  /// - values: [List] => All saved files of the extension given by the key
  static Map<String, List<FileData>> savedFilesByExtension = {};

  /// Only the files name (without extension)
  /// To include extension use [fullName]
  String filename;

  /// The files extension
  String extension;

  /// The file's content
  String content;

  /// The files full name including the extension, eg. 'example.json'
  String get fullName => '$filename.$extension';

  //=========STATIC METHODS=========//

  static void _saveFile(FileData fileData) {
    if (savedFilesByExtension.containsKey(fileData.extension) &&
        savedFilesByExtension[fileData.extension] != null) {
      savedFilesByExtension[fileData.extension]!.add(fileData);
    } else {
      savedFilesByExtension[fileData.extension] = List.of([
        fileData,
      ], growable: true);
    }
  }

  /// Saves this file into [savedFilesByExtension] if it doesn't exist yet.
  /// Returns if saving was successfull.
  ///
  /// To potentially override an existing FileData use [forceSave] instead
  bool trySave() {
    if (exists(filename, extension)) {
      return false;
    } else {
      _saveFile(this);
      return true;
    }
  }

  /// Always saves this instance in [savedFilesByExtension]. If a file with the same [filename] and [extension] already exists, it gets overridden!
  void forceSave() => _saveFile(this);

  /// checks if there is already a file with given [filename] and [extension] saved in [savedFilesByExtension]
  static bool exists(String filename, String extension) {
    return tryFind(filename, extension) != null;
  }

  /// checks if there is already a file with given [filename] and [extension] saved in [savedFilesByExtension] and returns it, if it does.
  static FileData? tryFind(String filename, String extension) {
    if (!savedFilesByExtension.containsKey(extension) ||
        savedFilesByExtension[extension] == null) {
      return null;
    }
    for (FileData file in savedFilesByExtension[extension]!) {
      if (file.filename == filename) {
        return file;
      }
    }
    return null;
  }

  /// Maybe obsolete?
  /// returns a copied list of all files of type [extension] saved in [savedFilesByExtension] or an empty list if none exist yet
  static List<FileData> tryGetFilesOfType(String extension) {
    return savedFilesByExtension[extension]?.toList() ?? <FileData>[];
  }

  /// Deletes
  static void delete(FileData file) {
    List? files = savedFilesByExtension[file.extension];
    files?.removeWhere(
      (element) => element == file,
    );
    if (files != null && files.isEmpty) {
      savedFilesByExtension.remove(file.extension);
    }
  }

  //=========INSTANCE METHODS=========//
  @override
  bool operator ==(Object other) {
    return (other is FileData && fullName == other.fullName);
  }

  @override
  int get hashCode => fullName.hashCode;

  @override
  String toString() => fullName;

  /// returns a formatted readable String of the whole file including it's content
  String get toFullString {
    String title = 'File $fullName:';
    String tDeco = '=' * title.length;
    return '$tDeco\n$title\n$tDeco\n$content ';
  }
}
