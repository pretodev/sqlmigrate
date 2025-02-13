class Migration {
  List<String> upStatements = [];
  List<String> downStatements = [];
  bool disableTransactionUp = false;
  bool disableTransactionDown = false;

  @override
  String toString() {
    return 'Migration(upStatements: $upStatements, downStatements: $downStatements)';
  }
}
