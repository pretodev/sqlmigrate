import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import 'models/environment.dart';

class ConfigurationReader {
  Environment findEnvironment(String configurationPath, [String name = '']) {
    try {
      final ioFile = File(configurationPath);
      final yamlString = ioFile.readAsStringSync();
      final yamlMap = jsonDecode(jsonEncode(loadYaml(yamlString))) as Map<String, dynamic>;

      Map<String, dynamic> sourceMap = yamlMap;
      if (_isPubspecFile(configurationPath)) {
        sourceMap = yamlMap['db_config'];
      }

      final environments =
          sourceMap.keys
              .map(
                (name) => Environment(
                  name: name,
                  dialect: sourceMap[name]['dialect'],
                  datasource: expandEnv(sourceMap[name]['datasource']),
                  tableName: sourceMap[name]['table'] ?? '',
                  directoryPath: sourceMap[name]['dir'],
                ),
              )
              .toList();

      if (environments.isEmpty) {
        throw 'No environment';
      }

      if (name.isNotEmpty) {
        return environments.firstWhere((e) => e.name == name);
      }
      return environments.first;
    } on PathNotFoundException {
      throw 'open $configurationPath: no such file or directory';
    }
  }

  bool _isPubspecFile(String configurationPath) {
    return configurationPath.endsWith('pubspec.yaml');
  }

  String expandEnv(String input) {
    final regExp = RegExp(r'\$(\w+)|\$\{(\w+)\}');
    return input.replaceAllMapped(regExp, (match) {
      final varName = match.group(1) ?? match.group(2);
      return Platform.environment[varName] ?? '';
    });
  }
}
