part of '../sqlmigrate.dart';

abstract class BaseParams {
  static const envKey = 'env';
  static const configKey = 'config';

  BaseParams(this.command) {
    parser(command.argParser);
  }

  final Command command;

  ArgResults? get results => command.argResults;

  @mustCallSuper
  void parser(ArgParser parser) {
    parser
      ..addOption(configKey, defaultsTo: _configurationPath, help: 'Configuration file to use.')
      ..addOption(envKey, defaultsTo: _environment, help: 'Environment');
  }

  final _configurationPath = 'pubspec.yaml';
  String get configurationPath => results?[configKey] ?? _configurationPath;

  final _environment = '';
  String get environment => results?[envKey] ?? _environment;
}
