import 'package:utopia_di/utopia_di.dart';

void main() {
  final di = DI.i;
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
