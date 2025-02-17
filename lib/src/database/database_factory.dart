import '../exceptions/database_exception.dart';
import 'database.dart';
import 'enum/database_dialects.dart';
import 'postgre_database.dart';

class DatabaseFactory {
  Database fromDialect(DatabaseDialects dialect, {required String tableName, required datasource}) {
    if (dialect == DatabaseDialects.postgres) {
      return PostgreDatabase(datasource: datasource, tableName: tableName);
    }
    throw DatabaseException(message: 'Unsupported dialect ${dialect.name}');
  }
}
