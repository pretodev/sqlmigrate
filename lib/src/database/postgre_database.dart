import 'package:postgres/postgres.dart';

import 'database.dart';
import 'models/migration_row.dart';

class PostgreDatabase extends Database {
  PostgreDatabase({required super.datasource, required super.tableName});

  Pool? _pool;

  @override
  Future<List<MigrationRow>> getAppliedMigrations() async {
    final result = await _pool?.execute('SELECT * FROM $tableName');
    final migrations =
        result?.map((item) {
          final map = item.toColumnMap();
          return MigrationRow(id: map['id'], appliedAt: map['applied_at']);
        }).toList();
    return migrations ?? [];
  }

  @override
  Future<void> applyMigration(String id, {required queries}) async {
    await _pool?.runTx((s) async {
      for (final query in queries) {
        await s.execute(query);
      }
      await s.execute(Sql.named('INSERT INTO $tableName(id) VALUES (@id)'), parameters: {'id': id});
    });
  }

  @override
  Future<void> removeMigration(String id, {required queries}) async {
    await _pool?.runTx((s) async {
      for (final query in queries) {
        await s.execute(query);
      }
      await s.execute(Sql.named('DELETE FROM $tableName WHERE id=@id'), parameters: {'id': id});
    });
  }

  @override
  Future<void> setup() async {
    final sql =
        'CREATE TABLE IF NOT EXISTS $tableName(id TEXT NOT NULL PRIMARY KEY, applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL)';
    await _pool?.execute(sql);
  }

  @override
  Future<void> connect() async {
    final (endpoint, sslMode) = _parseDataSource(datasource);
    _pool = Pool.withEndpoints([endpoint], settings: PoolSettings(sslMode: sslMode));
  }

  @override
  Future<void> disconnect() async {
    await _pool?.close();
  }

  (Endpoint, SslMode) _parseDataSource(String datasource) {
    String host = 'localhost';
    String port = '5432';
    String database = '';
    String username = '';
    String password = '';
    SslMode sslmode = SslMode.disable;

    final parts = datasource.trim().split(' ');
    for (final part in parts) {
      final [key, value] = part.split('=');
      if (key == 'host') host = value;
      if (key == 'port') port = value;
      if (key == 'dbname') database = value;
      if (key == 'user') username = value;
      if (key == 'password') password = value;
      if (key == 'sslmode') {
        sslmode =
            value == 'require'
                ? SslMode.require
                : value == 'verifyFull'
                ? SslMode.verifyFull
                : SslMode.disable;
      }
    }

    final endpoint = Endpoint(
      host: host,
      database: database,
      username: username,
      password: password,
      port: int.parse(port),
    );

    return (endpoint, sslmode);
  }
}
