# Changelog

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [0.2.0] - 2025-02-17

### Added
- Update **Postgres** dependency to version `3.5.2` in `pubspec.yaml` and `pubspec.lock`.
- **Enhance Configuration Handling**  
  - Introduced custom exceptions for configuration parsing (`ConfigurationException`).
  - Improved parsing logic for external and `pubspec.yaml`-based configurations.
- **Improve Database Dialect Support**  
  - Added custom exceptions for clearer database-related error reporting.
  - Enhanced error messages for dialect mismatches or invalid connections.
- **Error Handling Enhancements**  
  - Introduced custom exceptions for database setup errors.
  - Refined exception hierarchy to make it easier to catch and handle migration-specific errors.
- **Command Output & Logging**  
  - Improved logging to provide more context during migration commands.
  - More descriptive exception messages when commands fail.

### Changed
- **Refactor Exception Hierarchy**  
  - Replaced `InvalidConfigurationException` with `ConfigurationException`.
  - Restructured `SqlMigrateException` to better accommodate new custom exceptions.
- **Refactor CLI & Core Separation**  
  - Moved CLI-specific code out of core modules to simplify the codebase.

---

## [0.1.1] - 2025-02-14

### Fixed
- **Command Initialization**  
  - Fixed an issue where command parameters were not properly initialized in constructors.

### Changed
- **Rename Launch Configuration**  
  - Renamed launch configurations and updated default program arguments for clarity.

### Chore
- **License & Version Bump**  
  - Updated the project LICENSE.
  - Incremented version to `0.1.1`.

---

## [0.1.0] - 2025-02-13

### Added
- **Initial Release:** Launch of the `sqlmigrate` CLI tool.
- **PostgreSQL Support:** Initial support for managing PostgreSQL database migrations.
- **CLI Commands:**  
  - `up`: Applies one pending migration at a time.  
  - `down`: Reverts a migration.  
  - `new`: Creates a new migration file.
- **Flexible Configuration:**  
  - Configuration via `pubspec.yaml` using a dedicated `db_config` block.
  - Option to use an external YAML configuration file with custom environment names.
- **Migration File Structure:**  
  - Standardized naming convention (`YYYYMMDDHHMMSS-migration-name.sql`).
  - Defined markers for migration directions (`-- +migrate Up` and `-- +migrate Down`).

---

