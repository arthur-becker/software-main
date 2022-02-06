import 'package:mobile_app/services/auth/form_submission_status.dart';

class SignUpState {
  final String username;
  bool get isValidUsername => username.length > 3;

  final String email;
  bool get isValidEmail => email.isValidEmail();

  final String phoneNumber;
  bool get isPhoneNumber => phoneNumber.isValidEmail();

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}

extension Validator on String {
  
  // todo: unit test
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  // todo: unit test
  bool isValidPhoneNumber() {
    return RegExp(
            r'/(\b(00[1-9]{2}|0)|\B\+[1-9]{2})(\s?\(0\))?(\s)?[1-9]{2}(\s)?[0-9]{3}(\s)?[0-9]{2}(\s)?[0-9]{2}\b/')
        .hasMatch(this);
  }
}
