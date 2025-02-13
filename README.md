# sqlmigrate

A migration tool for Dart/Flutter projects that adds support for managing database migrations in a simple and practical way. **sqlmigrate** can be used both via the command line and as a development dependency in your Dart/Flutter application.

---

## Features

- **Simple CLI:** Manage migrations using straightforward commands.
- **Dart/Flutter Integration:** Use it as a development dependency in your project.
- **Flexible Configuration:** Configure via `pubspec.yaml` or an external YAML file.
- **Initial Focus on Supabase:** Currently supports PostgreSQL (with plans to add other databases in the future).
- **Step-by-Step Execution:** The `up` command applies one pending migration at a time, rather than all at once.

---

## Installation

Add `sqlmigrate` as a development dependency in your Dart/Flutter project:

```yaml
dev_dependencies:
  sqlmigrate: ^<version>
```

---

## Configuration

### Using `pubspec.yaml`

Include the migration configurations in your `pubspec.yaml` file:

```yaml
db_config:
  production:
    dialect: postgres
    datasource: dbname=${DB_NAME} user=${DB_USER} password=${DB_PASSWORD} sslmode=disable
    dir: migrations/postgres
    table: migrations
```

**Notes:**

- **db_config:** Mandatory configuration block.
- **production:** Environment name (can be any name, such as _development_, _test_, etc.).
- **dialect:** Database to be used for the environment.
- **datasource:** Database connection specifications. For PostgreSQL, include parameters like `host=`, `dbname=`, `port=`, `user=`, `password=`, and `sslmode` (options: `disable`, `require`, or `verifyFull`).
- **dir:** Directory where the SQL migration files are located.
- **table (optional):** Name of the table that will track the migrations in the database.

### Using an External Configuration File

Alternatively, you can use another YAML file for configuration (you don't need to define `db_config`). For example:

```yaml
development:
  dialect: sqlite3
  datasource: test.db
  dir: migrations/sqlite3

production:
  dialect: postgres
  datasource: dbname=myapp sslmode=disable
  dir: migrations/postgres
  table: migrations
```

Use the `--config` flag in the CLI to specify the path to this file.

---

## CLI Usage

The `sqlmigrate` command-line interface offers the following commands:

```bash
Usage: sql-migrate <command> [arguments]

Global options:
  -h, --help       Prints this usage information.
  -v, --version    Prints the version.

Available commands:
  down   Undo a database migration.
  new    Create a new migration.
  up     Migrate the database to the most recent version available.
```

### Important Flags

- **`--env`**: Specifies the environment to use. If not provided, the CLI will use the first environment defined in your configuration.
- **`--config`**: Specifies the path to an alternative configuration file (if you don't want to use `pubspec.yaml`).

---

## Migration Files Structure

Migration SQL files must follow this format:

```sql
-- +migrate Up
create table users(id serial primary key, name varchar(255));

-- +migrate Down
drop table users;
```

**Details:**

- **Up:** Defines the changes to be applied to the database.
- **Down:** Defines how to revert the changes made by the migration.

Each file should be named following this format:  
`YYYYMMDDHHMMSS-migration-name.sql`  
For example: `20250213173434-create-schema.sql`, where `create-schema` is the user-defined migration name.

---

## Final Considerations

- **Current Support:** The CLI currently supports only PostgreSQL. Support for other databases will be added in the future.
- **Migration Execution:** When executing the `up` command, the CLI applies only one pending migration at a time, rather than applying all pending migrations at once.

Contributions, feedback, and suggestions are welcome!

---

## License

This project is licensed under the [MIT License](LICENSE).

---

*Happy migrating!*