import 'package:auto_injector/auto_injector.dart';
import 'package:cli_util/cli_logging.dart';

import 'src/commands/down_command.dart';
import 'src/commands/new_command.dart';
import 'src/commands/up_command.dart';
import 'src/data/configuration/configuration_reader.dart';
import 'src/data/database/database_factory.dart';
import 'src/data/migration/migration_reader.dart';
import 'src/data/migration/migration_source.dart';
import 'src/data/migration/migration_writer.dart';
import 'src/usecases/apply_migrations.dart';
import 'src/usecases/create_migration.dart';

export 'src/commands/down_command.dart';
export 'src/commands/new_command.dart';
export 'src/commands/up_command.dart';

final container = AutoInjector(
  on: (i) {
    i.addLazySingleton<Logger>(() => Logger.standard());
    i.addLazySingleton(ConfigurationReader.new);
    i.addLazySingleton(MigrationWriter.new);
    i.addLazySingleton(MigrationReader.new);
    i.addLazySingleton(MigrationSource.new);
    i.addLazySingleton(DatabaseFactory.new);
    i.addLazySingleton(CreateMigration.new);
    i.addLazySingleton(ApplyMigrations.new);
    i.addLazySingleton(UpCommand.new);
    i.addLazySingleton(NewCommand.new);
    i.addLazySingleton(DownCommand.new);
    i.commit();
  },
);
