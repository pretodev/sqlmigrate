part of '../sqlmigrate.dart';

class NewCommand extends Command {
  NewCommand({required this.logger, required this.createMigration}) {
    params = NewCommandParams(this);
  }

  late final NewCommandParams params;

  final Logger logger;
  final CreateMigration createMigration;

  @override
  final name = 'new';

  @override
  final description = 'Create a new migration';

  @override
  String get invocation => 'app new [options] <name>\n\n  name                   The name of the migration';

  @override
  FutureOr? run() async {
    final result = await createMigration(
      migrationName: params.name,
      environmentName: params.environment,
      configPath: params.configurationPath,
    );
    switch (result) {
      case Ok():
        logger.stdout('Created migration ${result.value.path}');
      case Error():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
    return null;
  }
}
