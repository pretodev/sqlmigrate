import 'package:path/path.dart';

class MigrationFile {
  static const templateContent = _template;

  factory MigrationFile.empty(String name, {required String directory}) {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final fileName = '$year$month$day$hour$minute$second-$name.sql';
    return MigrationFile(join(directory, fileName));
  }

  MigrationFile(this.path);

  final String path;

  String get name => path.split('/').last.replaceAll('.sql', '');

  @override
  String toString() => 'MigrationFile($path)';
}

const _template = '''-- +migrate Up

-- +migrate Down
''';
