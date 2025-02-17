part of '../sqlmigrate.dart';

class Output {
  final logger = Logger.standard();

  void printCreatedMigration(MigrationFile file) {
    logger.stdout('Created migration ${file.path}');
  }

  void printException(Exception exception) {
    if (exception is SqlMigrateException) {
      logger.stdout('Failure to run command:\n ${exception.message}');
    } else {
      print(exception);
    }
  }

  void printNoMigrations(MigrationDirections direction) {
    logger.stdout('No migrations to apply (${direction.name})');
  }

  void printPlannedMigration(MigrationDirections direction, {required PlannedMigration data}) {
    final queries = switch (direction) {
      MigrationDirections.up => data.migration.upStatements,
      MigrationDirections.down => data.migration.downStatements,
    };
    logger.stdout('==> Would apply migration ${data.id} (${direction.name})');
    for (final query in queries) {
      logger.stdout(query);
    }
  }

  void printAppliedMigration(MigrationDirections direction, {required PlannedMigration data}) {
    logger.stdout('==> Applied migration ${data.id} (${direction.name})');
  }
}
