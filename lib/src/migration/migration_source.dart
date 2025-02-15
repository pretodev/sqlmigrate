import 'dart:io';

import 'models/migration_file.dart';

class MigrationSource {
  List<MigrationFile> findFiles(String directoryPath) {
    final dir = Directory(directoryPath);
    if (!dir.existsSync()) {
      throw 'invalid migration path';
    }

    final migrationFiles = <MigrationFile>[];
    for (final file in dir.listSync()) {
      if (file is File && file.path.endsWith('.sql')) {
        migrationFiles.add(MigrationFile(file.path));
      }
    }

    migrationFiles.sort((a, b) {
      final tsA = a.path.split('-')[0];
      final tsB = b.path.split('-')[0];
      return tsA.compareTo(tsB);
    });

    return migrationFiles;
  }
}
