part of '../sqlmigrate.dart';

class DownCommand extends Command {
  DownCommand({required this.output, required this.applyMigrations}) {
    params = DownCommandParams(this);
  }

  final Output output;
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
