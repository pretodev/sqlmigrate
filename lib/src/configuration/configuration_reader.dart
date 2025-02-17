import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import '../exceptions/invalid_configuration_exception.dart';
import 'models/environment.dart';

class ConfigurationReader {
  static const _pubspecRootKey = 'sqlmigrate';
  static const _envDirKey = 'dir';
  static const _envDataSourceKey = 'datasource';
  static const _envTableKey = 'table';
  static const _envDialectKey = 'dialect';

  Environment findEnvironment(String configurationPath, [String name = '']) {
    try {
      final ioFile = File(configurationPath);
      final yamlString = ioFile.readAsStringSync();

      Map<String, dynamic> sourceMap = _parse(yamlString);
      if (_isPubspecFile(configurationPath)) {
        sourceMap = sourceMap[_pubspecRootKey] ?? {};
        if (sourceMap.entries.isEmpty) {
          throw InvalidConfigurationException(
            message: 'Invalid configuration: Not found $_pubspecRootKey entry in "pubscpec.yaml"',
          );
        }
      }

      final environments =
          sourceMap //
              .keys
              .map((name) => _mapEnvironment(name, sourceMap[name]))
              .toList();

      if (environments.isEmpty) {
        throw InvalidConfigurationException(
          message: 'Invalid configuration: No environments found. Please define at least one environment.',
        );
      }

      if (name.isNotEmpty) {
        return environments.firstWhere((e) => e.name == name);
      }
      return environments.first;
    } on PathNotFoundException {
      throw InvalidConfigurationException(
        message: 'Invalid configuration: Could not open the file at "$configurationPath". No such file or directory.',
      );
    }
  }

  Map<String, dynamic> _parse(String content) {
    return jsonDecode(jsonEncode(loadYaml(content)));
  }

  bool _isPubspecFile(String configurationPath) {
    return configurationPath.endsWith('pubspec.yaml');
  }

  Environment _mapEnvironment(String name, Map<String, dynamic> envMap) {
    if (name.isEmpty) {
      throw InvalidConfigurationException(message: 'Invalid configuration: environment name is empty');
    }
    final directoryPath = (envMap[_envDirKey] as String?) ?? '';
    if (directoryPath.isEmpty) {
      throw InvalidConfigurationException(
        message: 'Invalid configuration: directory path (dir) property is missing or empty for environment "$name"',
      );
    }
    final dialect = (envMap[_envDialectKey] as String?) ?? '';
    if (dialect.isEmpty) {
      throw InvalidConfigurationException(
        message: 'Invalid configuration: "dialect" property is missing or empty for environment "$name"',
      );
    }
    final datasource = (envMap[_envDataSourceKey] as String?) ?? '';
    if (datasource.isEmpty) {
      throw InvalidConfigurationException(
        message: 'Invalid configuration: "datasource" property is missing or empty for environment "$name"',
      );
    }
    return Environment(
      name: name,
      dialect: dialect,
      datasource: datasource,
      directoryPath: directoryPath,
      tableName: (envMap[_envTableKey] as String?) ?? '',
    );
  }

  String expandEnv(String input) {
    final regExp = RegExp(r'\$(\w+)|\$\{(\w+)\}');
    return input.replaceAllMapped(regExp, (match) {
      final varName = match.group(1) ?? match.group(2);
      return Platform.environment[varName] ?? '';
    });
  }
}
