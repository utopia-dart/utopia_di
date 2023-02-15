import 'dart:math';

import 'package:test/test.dart';
import 'package:utopia_di/utopia_di.dart';

void main() async {
  final di = DI();
  di.setResource('rand', () => Random().nextInt(100));
  di.setResource(
    'first',
    (String second) => 'first-$second',
    injections: ['second'],
  );
  di.setResource('second', () => 'second');

  group('App', () {
    test('resource', () async {
      expect(di.getResource('second'), 'second');
      expect(di.getResource('first'), 'first-second');
      final resource = di.getResource('rand');
      assert(resource != null);
      expect(di.getResource('rand'), resource);
      expect(di.getResource('rand'), resource);
      expect(di.getResource('rand'), resource);
    });
  });
}
