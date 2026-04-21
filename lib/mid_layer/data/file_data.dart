class FileData {
  static Map<String, List<FileData>> savedFiles = {};
  String filename;
  String extension;
  String content;
  String get fullName => "$filename.$extension";

  /// Creates a new FileDataObject and saves it optionally
  FileData.create({
    required this.filename,
    required this.extension,
    this.content = "",
    bool save = true,
  }) {
    if (save) {
      if (!exists(filename, extension)) {
        _saveFile(this);
      } else {
        throw (Exception("File $fullName already exists!"));
      }
    }
  }

  factory FileData.fromFullName({
    required String fullName,
    String content = "",
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
  //=========STATIC METHODS=========//
  static void _saveFile(FileData fileData) {
    if (savedFiles.containsKey(fileData.extension) &&
        savedFiles[fileData.extension] != null) {
      savedFiles[fileData.extension]!.add(fileData);
    } else {
      savedFiles[fileData.extension] = List.of([fileData], growable: true);
    }
  }

  static bool exists(String filename, String extension) {
    return tryFind(filename, extension) != null;
  }

  static FileData? tryFind(String filename, String extension) {
    if (!savedFiles.containsKey(extension) || savedFiles[extension] == null) {
      return null;
    }
    for (FileData file in savedFiles[extension]!) {
      if (file.filename == filename) {
        return file;
      }
    }
    return null;
  }

  static List<FileData>? tryGetFilesOfType(String extension) {
    return savedFiles[extension];
  }

  static void _delete(FileData file) {
    savedFiles[file.extension]?.removeWhere(
      (element) => element.equals(file),
    );
  }

  //=========INSTANCE METHODS=========//

  bool equals(FileData other) {
    return fullName == other.fullName;
  }

  void delete() => _delete(this);

  @override
  String toString() => fullName;

  String get toFullString {
    String title = 'File $fullName:';
    String tDeco = '=' * title.length;
    return "$tDeco\n$title\n$tDeco\n$content ";
  }
}
