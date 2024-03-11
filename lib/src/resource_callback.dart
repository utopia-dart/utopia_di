/// Resource callback
class ResourceCallback {
  final String name;
  final List<String> injections;
  final Function callback;
  final bool reset;

  ResourceCallback(
    this.name,
    this.injections,
    this.callback, {
    this.reset = false,
  });

  ResourceCallback copyWith({bool? reset}) {
    return ResourceCallback(name, injections, callback, reset: reset ?? false);
  }
}
