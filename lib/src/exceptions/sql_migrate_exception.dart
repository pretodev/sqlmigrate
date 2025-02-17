abstract class SqlMigrateException implements Exception {
  SqlMigrateException({required this.message});

  final String message;

  @override
  String toString() {
    return message;
  }
}
