import 'package:utopia_di/utopia_di.dart';

void main() {
  final di = DI.i;
  di.set(Dependency('resource1', () => 'this is resource 1'));
  di.set(D('number1', () => 10));
  di.set(
    D(
      'dependentResource',
      (String resource1, int number1) => '$resource1 and $number1',
      dependencies: ['resource1', 'number1'],
    ),
  );

  print(di.get('resource1'));
  print(di.get('number1'));
  print(di.get('dependentResource'));
}
