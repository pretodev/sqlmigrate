class Environment {
  final String name;
  final String dialect;
  final String datasource;
  final String tableName;
  final String directoryPath;

  Environment({
    required this.name,
    required this.dialect,
    required this.datasource,
    this.tableName = '',
    required this.directoryPath,
  });

  @override
  String toString() {
    return 'ConfigurationEnvironment(name: $name, dialect: $dialect, datasource: $datasource, migrationTableName: $tableName, migrationDirectoryPath: $directoryPath)';
  }
}

extension ConfigurationEnvironmentList on List<Environment> {
  Environment fromName([String name = '']) {
    if (isEmpty) {
      throw 'No environment';
    }
    if (name.isNotEmpty) {
      return firstWhere(
        (e) => e.name == name,
      );
    }
    return first;
  }
}
