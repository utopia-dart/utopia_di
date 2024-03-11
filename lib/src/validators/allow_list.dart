import 'validator.dart';

/// Allow list validator
class AllowList<T> extends Validator {
  final List<T> _list;

  /// List of allowed values
  List<T> get list => _list;

  AllowList(this._list, {bool strict = false});

  /// Error description
  @override
  String getDescription() {
    return 'Value must of one of (${_list.join(", ")})';
  }

  /// Type of list
  @override
  String getType() {
    return T.toString();
  }

  /// Is array
  @override
  bool isArray() {
    return false;
  }

  /// Is valid
  /// Returns true if the given value
  /// is valid or false otherwise
  @override
  bool isValid(value) {
    if (value is List) return false;

    if (!_list.contains(value)) return false;

    return true;
  }
}
