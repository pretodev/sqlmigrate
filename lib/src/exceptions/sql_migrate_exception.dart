abstract class SqlMigrateException implements Exception {
  SqlMigrateException(this.title, {required this.message});

  final String title;

  final String message;

  @override
  String toString() {
    return '$title: $message';
  }
}
