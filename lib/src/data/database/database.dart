import 'models/migration_row.dart';

abstract class Database {
  final String tableName;
  final String datasource;

  Database({required this.datasource, required this.tableName});

  Future<void> connect();

  Future<void> disconnect();

  Future<void> setup();

  Future<List<MigrationRow>> getAppliedMigrations();

  Future<void> applyMigration(String id, {required List<String> queries});

  Future<void> removeMigration(String id, {required List<String> queries});
}
