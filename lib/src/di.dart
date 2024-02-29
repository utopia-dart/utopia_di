class DI {
  static DI? _instance;
  final Map<String, dynamic> _resources = {};
  static final Map<String, _ResourceCallback> _resourceCallbacks = {};

  static DI get instance {
    _instance ??= DI();
    return _instance!;
  }

  static DI get i => DI.instance;

  void set(
    String name,
    Function callback, {
    List<String> injections = const [],
  }) {
    _resourceCallbacks[name] =
        _ResourceCallback(name, injections, callback, reset: true);
  }

  Map<String, dynamic> getAll(List<String> names) {
    final resources = <String, dynamic>{};
    for (final name in names) {
      resources[name] = get(name);
    }
    return resources;
  }

  dynamic g<T>(String name, {bool fresh = false}) => get<T>(name, fresh: fresh);

  dynamic get<T>(String name, {bool fresh = false}) {
    if (_resources[name] == null ||
        fresh ||
        (_resourceCallbacks[name]?.reset ?? true)) {
      if (_resourceCallbacks[name] == null) {
        throw Exception('Failed to find resource: "$name"');
      }

      final params = getAll(_resourceCallbacks[name]!.injections);
      _resources[name] = Function.apply(
        _resourceCallbacks[name]!.callback,
        [...params.values],
      );
    }
    _resourceCallbacks[name] = _resourceCallbacks[name]!.copyWith(reset: false);
    final resource = _resources[name];
    if (resource is T) {
      return resource;
    }
    throw Exception('Resource type doesn\'t match');
  }

  void reset() {
    _resources.clear();
  }

  void resetResources() {
    _resourceCallbacks.clear();
  }
}

class _ResourceCallback {
  final String name;
  final List<String> injections;
  final Function callback;
  final bool reset;

  _ResourceCallback(
    this.name,
    this.injections,
    this.callback, {
    this.reset = false,
  });

  _ResourceCallback copyWith({bool? reset}) {
    return _ResourceCallback(name, injections, callback, reset: reset ?? false);
  }
}
