/// Dependency
/// Define your dependency, name and a callback
class Dependency {
  final String name;
  final Function callback;
  final List<String> dependencies;

  Dependency(this.name, this.callback, {this.dependencies = const []});

  Dependency inject(String name) {
    if (dependencies.contains(name)) {
      throw Exception('Dependency already declared for $name');
    }
    dependencies.add(name);
    return this;
  }
}

/// Another shorter name for Dependency
class D extends Dependency {
  D(super.name, super.callback, {super.dependencies});
}
