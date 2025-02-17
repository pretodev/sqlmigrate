part of '../sqlmigrate.dart';

class NewCommand extends Command {
  NewCommand({required this.output, required this.createMigration}) {
    params = NewCommandParams(this);
  }

  final Output output;
  final CreateMigration createMigration;

  late final NewCommandParams params;

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
        output.printCreatedMigration(result.value);
      case Error():
        output.printException(result.error);
    }
  }
}
