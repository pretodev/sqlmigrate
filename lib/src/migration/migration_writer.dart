import 'dart:io';

import 'models/migration_file.dart';

class MigrationWriter {
  void write(MigrationFile file, String content) {
    final ioFile = File(file.path);
    if (!ioFile.parent.existsSync()) {
      ioFile.parent.createSync(recursive: true);
    }

    if (ioFile.existsSync()) {
      throw FileSystemException('file exists', file.path);
    }
    ioFile.writeAsStringSync(content);
  }
}
