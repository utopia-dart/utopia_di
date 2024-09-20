import 'dart:math';

import 'package:test/test.dart';
import 'package:utopia_di/utopia_di.dart';

void main() async {
  final di = DI();
  di.set(D('rand', () => Random().nextInt(100)));
  di.set(D(
    'first',
    (String second) => 'first-$second',
    dependencies: ['second'],
  ));
  di.set(D('second', () => 'second'));

  di.set(D('second', () => 'another second'), context: 'another');
  di.set(D('third', () => 'another third'), context: 'another');

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
            'Exception: Failed to find dependency: "third"',
          ),
        ),
      );
    });
  });
}
