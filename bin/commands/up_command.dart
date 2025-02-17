part of '../sqlmigrate.dart';

class UpCommand extends Command {
  UpCommand({required this.output, required this.applyMigrations}) {
    params = UpCommandParams(this);
  }

  final Output output;
  final ApplyMigrations applyMigrations;

  late final UpCommandParams params;

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
        if (result.value.isEmpty) {
          output.printNoMigrations(direction);
          return;
        }
        for (final data in result.value) {
          if (params.dryRun) {
            output.printPlannedMigration(direction, data: data);
          } else {
            output.printAppliedMigration(direction, data: data);
          }
        }
      case Error():
        output.printException(result.error);
    }
  }
}
