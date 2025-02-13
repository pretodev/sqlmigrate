import 'dart:async';

import 'package:args/command_runner.dart';

import '../data/migration/enum/migration_directions.dart';
import '../output/output.dart';
import '../usecases/apply_migrations.dart';
import '../values/result.dart';
import 'up_command_params.dart';

class UpCommand extends Command {
  UpCommand({required this.applyMigrations});

  final ApplyMigrations applyMigrations;

  late final params = UpCommandParams(this);
  @override
  final name = 'up';

  @override
  final description = 'Migrates the database to the most recent version available';

  @override
  FutureOr? run() async {
    const direction = MigrationDirections.up;

    final result = await applyMigrations(
      direction,
      dryRun: params.dryRun,
      configPath: params.configurationPath,
      environmentName: params.environment,
    );

    switch (result) {
      case Ok():
        for (final data in result.value) {
          if (params.dryRun) {
            Output.printPlannedMigration(direction, data: data);
          } else {
            Output.printAppliedMigration(direction, data: data);
          }
        }
      case Error():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
