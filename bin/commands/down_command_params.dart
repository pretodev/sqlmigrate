part of '../sqlmigrate.dart';

class DownCommandParams extends BaseParams {
  static const String limitKey = 'limit';
  static const String versionKey = 'version';
  static const String dryRunKey = 'dry-run';

  DownCommandParams(super.command);

  final _migrationLimit = 0;
  int get migrationLimit => int.parse(results?[limitKey]);

  String? get version => results?[versionKey];

  bool get dryRun => results?[dryRunKey] ?? false;

  @override
  void parser(ArgParser parser) {
    super.parser(parser);
    parser
      ..addOption(limitKey, defaultsTo: '$_migrationLimit', help: 'Limit the number of migrations (0 = unlimited).')
      ..addOption(versionKey, help: 'Run migrate up to a specific version.')
      ..addFlag(dryRunKey, help: 'Don\'t apply migrations, just print them.');
  }
}
