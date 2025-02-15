part of '../sqlmigrate.dart';

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
    return null;
  }
}
