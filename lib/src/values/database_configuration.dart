import 'package:meta/meta.dart';

import 'database_environments.dart';

@immutable
class DatabaseConfiguration {
  const DatabaseConfiguration({
    required this.dialect,
    required this.environment,
    required this.datasource,
    required this.migrationDirectoryPath,
    required this.migrationTable,
  });

  final String dialect;
  final DatabaseEnvironments environment;
  final String datasource;
  final String migrationDirectoryPath;
  final String? migrationTable;
}
