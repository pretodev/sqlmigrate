import 'database.dart';
import 'enum/database_dialects.dart';
import 'postgre_database.dart';

class DatabaseFactory {
  Database fromDialect(
    DatabaseDialects dialect, {
    required String tableName,
    required datasource,
  }) {
    if (dialect == DatabaseDialects.postgres) {
      return PostgreDatabase(
        datasource: datasource,
        tableName: tableName,
      );
    }
    throw 'Unsupported dialect $dialect';
  }
}
