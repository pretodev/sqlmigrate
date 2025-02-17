import '../../exceptions/database_exception.dart';

enum DatabaseDialects {
  postgres;

  static DatabaseDialects fromString(String name) {
    try {
      return DatabaseDialects.values.firstWhere((item) => item.name == name);
    } on StateError {
      final dialectsNames = values.map((e) => e.name).join(', ');
      throw DatabaseException(message: 'Unsupported dialect $name, available dialects are: $dialectsNames');
    }
  }
}
