import 'package:utopia_di/utopia_di.dart';

void main() {
  final di = DI.i;
  di.set('resource1', () => 'this is resource 1');
  di.set('number1', () => 10);
  di.set(
    'dependentResource',
    (String resource1, int number1) => '$resource1 and $number1',
    injections: ['resource1', 'number1'],
  );

  print(di.get('resource1'));
  print(di.get('number1'));
  print(di.get('dependentResource'));
}
