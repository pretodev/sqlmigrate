import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import '../exceptions/configuration_exception.dart';
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
          throw ConfigurationException(message: 'Not found $_pubspecRootKey entry in "pubscpec.yaml"');
        }
      }

      final environments =
          sourceMap //
              .keys
              .map((name) => _mapEnvironment(name, sourceMap[name]))
              .toList();

      if (environments.isEmpty) {
        throw ConfigurationException(message: 'No environments found. Please define at least one environment.');
      }

      if (name.isNotEmpty) {
        return environments.firstWhere((e) => e.name == name);
      }
      return environments.first;
    } on PathNotFoundException {
      throw ConfigurationException(
        message: 'Could not open the file at "$configurationPath". No such file or directory.',
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
      throw ConfigurationException(message: 'Environment name is empty');
    }
    final directoryPath = (envMap[_envDirKey] as String?) ?? '';
    if (directoryPath.isEmpty) {
      throw ConfigurationException(
        message: 'Directory path (dir) property is missing or empty for environment "$name"',
      );
    }
    final dialect = (envMap[_envDialectKey] as String?) ?? '';
    if (dialect.isEmpty) {
      throw ConfigurationException(message: '"Dialect" property is missing or empty for environment "$name"');
    }
    final datasource = (envMap[_envDataSourceKey] as String?) ?? '';
    if (datasource.isEmpty) {
      throw ConfigurationException(message: '"Datasource" property is missing or empty for environment "$name"');
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
