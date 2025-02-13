import '../data/configuration/configuration_reader.dart';
import '../data/database/database.dart';
import '../data/database/database_factory.dart';
import '../data/database/enum/database_dialects.dart';
import '../data/migration/enum/migration_directions.dart';
import '../data/migration/migration_reader.dart';
import '../data/migration/migration_source.dart';
import '../data/migration/models/migration.dart';
import '../data/migration/models/migration_file.dart';
import '../values/result.dart';

typedef PlannedMigration = ({String id, Migration migration});

class ApplyMigrations {
  ApplyMigrations({
    required MigrationSource migrationSource,
    required DatabaseFactory databaseFactory,
    required ConfigurationReader configurationReader,
    required MigrationReader migrationReader,
  }) : _databaseFactory = databaseFactory,
       _configurationReader = configurationReader,
       _migrationSource = migrationSource,
       _migrationReader = migrationReader;

  final MigrationSource _migrationSource;
  final MigrationReader _migrationReader;
  final DatabaseFactory _databaseFactory;
  final ConfigurationReader _configurationReader;

  AsyncResult<List<PlannedMigration>> call(
    MigrationDirections direction, {
    required String configPath,
    String environmentName = '',
    bool dryRun = false,
  }) async {
    Database? database;
    try {
      final environment = _configurationReader.findEnvironment(configPath, environmentName);

      database = _databaseFactory.fromDialect(
        DatabaseDialects.postgres,
        tableName: environment.tableName,
        datasource: environment.datasource,
      );

      final migrationFiles = _migrationSource.findFiles(environment.directoryPath);

      await database.connect();
      await database.setup();

      final migrationRows = await database.getAppliedMigrations();
      final orderedMigrations = switch (direction) {
        MigrationDirections.up => migrationFiles.where((file) {
          final names = migrationRows.map((row) => row.id);
          return !names.contains(file.name);
        }),
        MigrationDirections.down => migrationFiles.reversed.where((file) {
          final names = migrationRows.map((row) => row.id);
          return names.contains(file.name);
        }),
      };

      final plannedMigrations =
          orderedMigrations //
              .toList()
              .sublist(0, 1)
              .map(_plannedMigration)
              .toList();

      if (dryRun) {
        return Result.ok(plannedMigrations);
      }

      for (final plannedMigration in plannedMigrations) {
        final (:id, :migration) = plannedMigration;

        switch (direction) {
          case MigrationDirections.up:
            await database.applyMigration(id, queries: migration.upStatements);
            break;
          case MigrationDirections.down:
            await database.removeMigration(id, queries: migration.downStatements);
            break;
        }
      }

      return Result.ok(plannedMigrations);
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      await database?.disconnect();
    }
  }

  PlannedMigration _plannedMigration(MigrationFile file) {
    final migration = _migrationReader.read(file);
    return (id: file.name, migration: migration);
  }
}
