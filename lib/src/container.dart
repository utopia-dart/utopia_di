import 'dart:collection';

import 'dependency.dart';

class Container {
  // Store dependencies and instances
  final Map<String, Dependency> _dependencies = HashMap();
  final Map<String, dynamic> _instances = HashMap();

  // Constructor
  Container() {
    Dependency di = Dependency('di', () => this);
    _dependencies[di.name] = di;
  }

  // Set a dependency
  Container set(Dependency dependency) {
    if (_instances.containsKey(dependency.name)) {
      _instances.remove(dependency.name);
    }

    _dependencies[dependency.name] = dependency;
    return this;
  }

  // Get a dependency
  dynamic get<T>(String name) {
    if (!has(name)) {
      throw Exception('Failed to find dependency: "$name"');
    }

    final resource = inject(_dependencies[name]!);
    if (resource is T) {
      return resource;
    }
    throw Exception('Resource type doesn\'t match');
  }

  // Check if a dependency exists
  bool has(String name) {
    return _dependencies.containsKey(name);
  }

  // Resolve the dependencies of a given injection
  dynamic inject(Dependency injection, {bool fresh = false}) {
    if (_instances.containsKey(injection.name) && !fresh) {
      return _instances[injection.name];
    }

    List<dynamic> arguments = [];

    for (String dependency in injection.dependencies) {
      if (_instances.containsKey(dependency)) {
        arguments.add(_instances[dependency]);
        continue;
      }

      if (!_dependencies.containsKey(dependency)) {
        throw Exception('Failed to find dependency: "$dependency"');
      }

      arguments.add(get(dependency));
    }

    var resolved = Function.apply(injection.callback, arguments);
    _instances[injection.name] = resolved;
    return resolved;
  }

  // Refresh a dependency
  Container refresh(String name) {
    if (_instances.containsKey(name)) {
      _instances.remove(name);
    }

    return this;
  }
}
