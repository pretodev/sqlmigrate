abstract class MigrationException implements Exception {
  final String message;

  MigrationException({required this.message});

  @override
  String toString() {
    return message;
  }
}
