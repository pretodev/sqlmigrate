import 'dart:async';

import 'package:args/command_runner.dart';

import '../data/migration/enum/migration_directions.dart';
import '../output/output.dart';
import '../usecases/apply_migrations.dart';
import '../values/result.dart';
import 'down_command_params.dart';

class DownCommand extends Command {
  DownCommand({required this.applyMigrations}) {
    params = DownCommandParams(this);
  }

  final ApplyMigrations applyMigrations;

  late final DownCommandParams params;
  @override
  final name = 'down';

  @override
  final description = 'Undo a database migration';

  @override
  FutureOr? run() async {
    const direction = MigrationDirections.down;

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
