import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort, invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < 8) return PasswordValidationError.tooShort;
    if (!_passwordRegExp.hasMatch(value))
      return PasswordValidationError.invalid;
    return null;
  }

  static String? showPasswordErrorMessage(PasswordValidationError? error) {
    if (error == PasswordValidationError.empty) {
      return 'Password cannot be empty';
    } else if (error == PasswordValidationError.tooShort) {
      return 'Password must be at least 8 characters';
    } else if (error == PasswordValidationError.invalid) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }
}
