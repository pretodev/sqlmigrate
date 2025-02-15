import 'dart:io';

import 'enum/migration_directions.dart';
import 'models/migration.dart';
import 'models/migration_file.dart';

class MigrationReader {
  static const _commandPrefix = '-- +migrate';
  static const _optionNoTransaction = 'no-transaction';
  static const _lineSeparator = '';

  Migration read(MigrationFile migrationFile) {
    final file = File(migrationFile.path);
    final lines = file //
        .readAsStringSync()
        .split(RegExp(r'\r?\n'))
        .where(
          (line) => !_isCommentLine(line.trim()) && line.trim().isNotEmpty,
        );

    MigrationDirections? currentDirection;

    final result = Migration();
    final buf = StringBuffer();
    bool statementEnded = false;
    bool ignoreSemicolons = false;

    for (final line in lines) {
      if (_isCommand(line)) {
        final cmd = _parseCommand(line);
        switch (cmd.command) {
          case 'Up':
            if (buf.toString().trim().isNotEmpty) {
              throw Exception(
                "ERROR: The last statement must be ended by a semicolon or '-- +migrate StatementEnd' marker",
              );
            }
            currentDirection = MigrationDirections.up;
            if (cmd.hasOption(_optionNoTransaction)) {
              result.disableTransactionUp = true;
            }
            break;
          case 'Down':
            if (buf.toString().trim().isNotEmpty) {
              throw Exception(
                "ERROR: The last statement must be ended by a semicolon or '-- +migrate StatementEnd' marker",
              );
            }
            currentDirection = MigrationDirections.down;
            if (cmd.hasOption(_optionNoTransaction)) {
              result.disableTransactionDown = true;
            }
            break;
          case 'StatementBegin':
            if (currentDirection != null) {
              ignoreSemicolons = true;
            }
            break;
          case 'StatementEnd':
            if (currentDirection != null) {
              statementEnded = ignoreSemicolons;
              ignoreSemicolons = false;
            }
            break;
        }
      }

      if (currentDirection == null) {
        continue;
      }

      final isLineSeparator = !ignoreSemicolons &&
          _lineSeparator.isNotEmpty &&
          line == _lineSeparator;

      if (!isLineSeparator && !line.startsWith('-- +')) {
        buf.writeln(line);
      }

      final isSemicolon = !ignoreSemicolons && _endsWithSemicolon(line);

      if (isSemicolon || isLineSeparator || statementEnded) {
        statementEnded = false;
        final statement = buf.toString().trim();
        switch (currentDirection) {
          case MigrationDirections.up:
            result.upStatements.add(statement);
          case MigrationDirections.down:
            result.downStatements.add(statement);
        }
        buf.clear();
      }
    }

    return result;
  }

  MigrationCommand _parseCommand(String line) {
    final trimmed = line.substring(_commandPrefix.length).trim();
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      throw Exception('Comando de migração inválido: $line');
    }
    final command = parts[0];
    final options = parts.sublist(1);
    return MigrationCommand(command, options);
  }

  bool _isCommentLine(String line) {
    return line.startsWith('--') && !line.startsWith('-- +');
  }

  bool _isCommand(String line) {
    return line.startsWith(_commandPrefix);
  }

  bool _endsWithSemicolon(String line) {
    String prev = '';
    final words = line.split(RegExp(r'\s+'));
    for (final word in words) {
      if (word.startsWith('--')) {
        break;
      }
      prev = word;
    }
    return prev.endsWith(';');
  }
}

class MigrationCommand {
  final String command;
  final List<String> options;

  MigrationCommand(this.command, this.options);

  bool hasOption(String option) => options.contains(option);
}
