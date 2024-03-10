import 'dart:math';

import 'package:test/test.dart';
import 'package:utopia_di/utopia_di.dart';

void main() async {
  final di = DI();
  di.set('rand', () => Random().nextInt(100));
  di.set(
    'first',
    (String second) => 'first-$second',
    injections: ['second'],
  );
  di.set('second', () => 'second');

  di.set('second', () => 'another second', context: 'another');
  di.set('third', () => 'another third', context: 'another');

  group('Utopia DI', () {
    test('resource', () async {
      expect(di.get('second'), 'second');
      expect(di.get('first'), 'first-second');
      final resource = di.get('rand');
      assert(resource != null);
      expect(di.get('rand'), resource);
      expect(di.get('rand'), resource);
      expect(di.get('rand'), resource);
    });

    test('context resource', () async {
      expect(di.get('second', context: 'another'), 'another second');
      expect(di.get('third', context: 'another'), 'another third');
      expect(
        () => di.get('third'),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            '',
            'Exception: Failed to find resource: "third"',
          ),
        ),
      );
    });
  });
}
