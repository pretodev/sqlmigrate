# Changelog

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/).

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

## [Unreleased]

### Added
- Future support for additional databases besides PostgreSQL.
- Potential enhancements and additional CLI features based on user feedback.
