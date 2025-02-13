import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:sqlmigrate/sqlmigrate.dart';

void main(List<String> arguments) {
  final runner =
      CommandRunner('sql-migrate', 'A CLI tool for SQL migrations')
        ..addCommand(container.get<UpCommand>())
        ..addCommand(container.get<NewCommand>())
        ..addCommand(container.get<DownCommand>());

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
