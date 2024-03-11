import 'param.dart';
import 'validators/validator.dart';

/// Utopia Hook, extended by various other
/// utopia libraries.
///
/// A hook provides an action to be executed
class Hook {
  /// Description
  String description = '';
  List<String> _groups = [];
  static int _counter = 0;
  final Map<String, Param> _params = {};
  final List<String> _injections = [];
  late int order;
  late Function _action;

  final List<String> _argsOrder = [];

  /// Order of arguments
  List<String> get argsOrder => _argsOrder;

  /// Injections
  List<String> get injections => _injections;

  /// Parameters
  Map<String, Param> get params => _params;

  /// Get groups
  List<String> getGroups() => _groups;

  /// Get action
  Function getAction() => _action;

  Hook() {
    Hook._counter++;
    order = _counter;
    _action = () {};
  }

  /// Hooks action to be executed
  /// when executing hook
  Hook action(Function action) {
    _action = action;
    return this;
  }

  /// Set hook description
  Hook desc(String description) {
    this.description = description;
    return this;
  }

  /// Set hook groups
  Hook groups(List<String> groups) {
    _groups = groups;
    return this;
  }

  /// Inject dependencies
  Hook inject(String injection) {
    if (_injections.contains(injection)) {
      throw Exception("Injection already declared for $injection");
    }
    _injections.add(injection);
    _argsOrder.add(injection);
    return this;
  }

  /// Set hook param
  Hook param({
    required String key,
    dynamic defaultValue,
    Validator? validator,
    String description = '',
    bool optional = false,
  }) {
    _params[key] = Param(
      defaultValue: defaultValue,
      validator: validator,
      description: description,
      value: null,
      optional: optional,
    );
    _argsOrder.add(key);
    return this;
  }
}
