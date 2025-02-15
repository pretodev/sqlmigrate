import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:auto_injector/auto_injector.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:meta/meta.dart';
import 'package:sqlmigrate/sqlmigrate.dart';

part './commands/base_params.dart';
part './commands/down_command.dart';
part './commands/down_command_params.dart';
part './commands/new_command.dart';
part './commands/new_command_params.dart';
part './commands/up_command.dart';
part './commands/up_command_params.dart';
part './output/output.dart';

final i = AutoInjector(
  on: (i) {
    i.addLazySingleton<Logger>(() => Logger.standard());
    i.addLazySingleton(ConfigurationReader.new);
    i.addLazySingleton(MigrationWriter.new);
    i.addLazySingleton(MigrationReader.new);
    i.addLazySingleton(MigrationSource.new);
    i.addLazySingleton(DatabaseFactory.new);
    i.addLazySingleton(CreateMigration.new);
    i.addLazySingleton(ApplyMigrations.new);
    i.addLazySingleton(DownCommand.new);
    i.addLazySingleton(UpCommand.new);
    i.addLazySingleton(NewCommand.new);
    i.commit();
  },
);

void main(List<String> arguments) {
  final runner =
      CommandRunner('sql-migrate', 'A CLI tool for SQL migrations')
        ..addCommand(i.get<UpCommand>())
        ..addCommand(i.get<NewCommand>())
        ..addCommand(i.get<DownCommand>());

  runner.argParser.addFlag('version', abbr: 'v', negatable: false, help: 'Prints the version');

  try {
    runner.run(arguments).catchError((error) {
      if (error is! UsageException) throw error;
      print(error);
      exit(64);
    });
  } catch (error) {
    print('Error: $error');
    exit(1);
  }
}
