import 'sql_migrate_exception.dart';

class DatabaseException extends SqlMigrateException {
  DatabaseException({required super.message}) : super('Database Error:');
}
