# Utopia Dependency Injection

Light & Fast Dart Dependency Injection Library

## Features

- Dependency injection

## Getting started

Add dependency

```yaml
dependencies:
    utopia_di: <latest>
```

## Usage

It's very simple to use. Use it by creating a instance or use a singleton instance from the library.

```dart
import 'package:utopia_di/utopia_di.dart';

final di = DI(); //you can also use `DI.instance` or `DI.i`

void main() {
  di.setResource('resource1', () => 'this is resource 1');
  di.setResource('number1', () => 10);
  di.setResource(
    'dependentResource',
    (String resource1, int number1) => '$resource1 and $number1',
    injections: ['resource1', 'number1'],
  );

  print(di.getResource('resource1'));
  print(di.getResource('number1'));
  print(di.getResource('dependentResource'));
}
```

## Copyright and license

The MIT License (MIT) [https://www.opensource.org/licenses/mit-license.php](https://www.opensource.org/licenses/mit-license.php)
