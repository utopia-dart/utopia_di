import 'resource_callback.dart';

/// Dependency injection
///
/// Simple and easy dependency injection
/// for your Dart applications.
///
/// Part of Utopia Dart ecosystem,
/// but can be used independently.
class DI {
  static const defaultContext = 'utopia';
  static DI? _instance;
  final Map<String, Map<String, dynamic>> _resources = {};
  final Map<String, Map<String, ResourceCallback>> _resourceCallbacks = {};

  /// Get singleton instance
  static DI get instance {
    _instance ??= DI();
    return _instance!;
  }

  /// Get singleton instance
  static DI get i => DI.instance;

  /// Set a resource callback
  void set(
    String name,
    Function callback, {
    List<String> injections = const [],
    String context = defaultContext,
  }) {
    _resourceCallbacks[context] ??= {};
    _resourceCallbacks[context]![name] =
        ResourceCallback(name, injections, callback, reset: true);
  }

  /// Get all the resources set in the context
  Map<String, dynamic> getAll(List<String> names,
      {String context = defaultContext}) {
    final resources = <String, dynamic>{};
    for (final name in names) {
      resources[name] = get(name, context: context);
    }
    return resources;
  }

  /// Get a resource
  dynamic g<T>(String name, {bool fresh = false}) => get<T>(name, fresh: fresh);

  /// Get a resource
  dynamic get<T>(String name,
      {String context = defaultContext, bool fresh = false}) {
    _resources[context] ??= <String, dynamic>{};
    _resourceCallbacks[context] ??= {};

    final resources = _resources[context]!;
    var resourceCallbacks = _resourceCallbacks[context]!;
    if (resourceCallbacks.isEmpty || resourceCallbacks[name] == null) {
      // use default context when not found in the context
      resourceCallbacks = _resourceCallbacks[defaultContext] ?? {};
    }
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

  /// Reset cached resources
  void resetResources([String? context]) {
    if (context != null) {
      (_resources[context] ?? {}).clear();
      return;
    }
    _resources.clear();
  }

  /// Resets all the dependencies
  void reset() {
    _resourceCallbacks.clear();
  }
}
