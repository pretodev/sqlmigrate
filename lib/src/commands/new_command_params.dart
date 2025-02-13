import 'base_params.dart';

class NewCommandParams extends BaseParams {
  NewCommandParams(super.command);

  String get name {
    if (results?.rest.isEmpty ?? true) {
      throw 'A name for the migration is needed';
    }
    final name = results?.rest.first ?? '';
    if (name.isEmpty) {
      throw 'A name for the migration is needed';
    }
    return name;
  }
}
