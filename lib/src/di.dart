import 'dart:collection';

import 'dependency.dart';
import 'container.dart';

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

  final Map<String, Container> _containers = HashMap();

  DI() {
    _containers[defaultContext] = Container();
  }

  /// Get singleton instance
  static DI get instance {
    _instance ??= DI();
    return _instance!;
  }

  /// Get singleton instance
  static DI get i => DI.instance;

  /// Set a resource callback
  DI set(
    Dependency dependency, {
    String context = defaultContext,
  }) {
    _containers[context] ??= Container();
    _containers[context]!.set(dependency);
    return this;
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
  T g<T>(String name, {bool fresh = false}) => get<T>(name, fresh: fresh);

  /// Get a resource
  T get<T>(String name,
      {String context = defaultContext, bool fresh = false}) {
    if (!_containers.containsKey(context)) {
      throw Exception('Context $context does not exist.');
    }

    if (fresh) {
      _containers[context]!.refresh(name);
    }
    return _containers[context]!.get<T>(name);
  }

  Container? getContainer(String context) {
    return _containers[context];
  }

  DI resetContext(String context) {
    if (_containers.containsKey(context)) {
      _containers.remove(context);
    }
    return this;
  }

  DI reset() {
    _containers.clear();
    _containers[defaultContext] = Container();
    return this;
  }
}
