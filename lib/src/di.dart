class DI {
  static DI? _instance;
  final Map<String, Map<String, dynamic>> _resources = {};
  static final Map<String, Map<String, _ResourceCallback>> _resourceCallbacks =
      {};

  static DI get instance {
    _instance ??= DI();
    return _instance!;
  }

  static DI get i => DI.instance;

  void set(
    String name,
    Function callback, {
    List<String> injections = const [],
    String context = 'utopia',
  }) {
    _resourceCallbacks[context] ??= {};
    _resourceCallbacks[context]![name] =
        _ResourceCallback(name, injections, callback, reset: true);
  }

  Map<String, dynamic> getAll(List<String> names, {String context = 'utopia'}) {
    final resources = <String, dynamic>{};
    for (final name in names) {
      resources[name] = get(name, context: context);
    }
    return resources;
  }

  dynamic g<T>(String name, {bool fresh = false}) => get<T>(name, fresh: fresh);

  dynamic get<T>(String name, {String context = 'utopia', bool fresh = false}) {
    _resources[context] ??= <String, dynamic>{};
    _resourceCallbacks[context] ??= {};

    final resources = _resources[context]!;
    final resourceCallbacks = _resourceCallbacks[context]!;
    if (resources[name] == null ||
        fresh ||
        (resourceCallbacks[name]?.reset ?? true)) {
      if (resourceCallbacks[name] == null) {
        throw Exception('Failed to find resource: "$name"');
      }

      final params = getAll(resourceCallbacks[name]!.injections);
      resources[name] = Function.apply(
        resourceCallbacks[name]!.callback,
        [...params.values],
      );
    }
    resourceCallbacks[name] = resourceCallbacks[name]!.copyWith(reset: false);
    final resource = resources[name];
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
