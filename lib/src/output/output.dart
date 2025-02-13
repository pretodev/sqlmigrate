import '../data/migration/enum/migration_directions.dart';
import '../usecases/apply_migrations.dart';

class Output {
  static void printPlannedMigration(MigrationDirections direction, {required PlannedMigration data}) {
    final queries = switch (direction) {
      MigrationDirections.up => data.migration.upStatements,
      MigrationDirections.down => data.migration.downStatements,
    };
    print('==> Would apply migration ${data.id} (${direction.name})');
    for (final query in queries) {
      print(query);
    }
  }

  static void printAppliedMigration(MigrationDirections direction, {required PlannedMigration data}) {
    print('==> Applied migration ${data.id} (${direction.name})');
  }
}
