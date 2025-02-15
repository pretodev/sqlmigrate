import 'configuration/configuration_reader.dart';
import 'migration/migration_writer.dart';
import 'migration/models/migration_file.dart';
import 'result/result.dart';

class CreateMigration {
  final ConfigurationReader _configurationReader;
  final MigrationWriter _migrationFileWriter;

  CreateMigration({required ConfigurationReader configurationReader, required MigrationWriter migrationFileWriter})
    : _configurationReader = configurationReader,
      _migrationFileWriter = migrationFileWriter;

  AsyncResult<MigrationFile> call({
    required String configPath,
    required String migrationName,
    String environmentName = '',
  }) async {
    final environment = _configurationReader.findEnvironment(configPath, environmentName);

    final migration = MigrationFile.empty(migrationName, directory: environment.directoryPath);

    _migrationFileWriter.write(migration, MigrationFile.templateContent);

    return Result.ok(migration);
  }
}
