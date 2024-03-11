import 'validators/validator.dart';

/// Param
class Param {
  final dynamic defaultValue;
  final Validator? validator;
  final String description;
  final dynamic value;
  final bool optional;

  Param({
    required this.defaultValue,
    required this.validator,
    required this.description,
    required this.value,
    required this.optional,
  });
}
