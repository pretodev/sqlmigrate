part of '../sqlmigrate.dart';

class UpCommand extends Command {
  UpCommand({required this.applyMigrations}) {
    params = UpCommandParams(this);
  }

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
    return null;
  }
}
