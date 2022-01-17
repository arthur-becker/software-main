///Implementierungsvorschlag @christoph
///eine klasse, über welche statische methoden/futures/variablen aufrufbar sind
///nötige Methoden/Futures/...
/// - Log in mit e-mail (am besten Future<String>) -> rückübergabe der erhaltenen ID
/// - Log in mit Telefonnummer (...) -> ... (muss ggf. noch in amplify hinterlegt werden -> im zweifel @CoachBenedetto fragen)
/// - Log out (am besten Future<bool>) -> rückgabe true wenn erfolgreich
/// - Aktuelle user id (Future<String>) -> wenn nicht eingeloggt null
/// - login status (Future<LoginStatus>) -> Enum für LoginStatus erstellen
/// - wir verwenden nicht das login ui von amplify zunächst; können wir uns allerdings gemeinsam mit den designern nochmal anschauen
/// - bei login immer an device erinnern
/// - bei logout device vergewssen

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  Future<String?> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
          .firstWhere((element) => element.userAttributeKey == 'id')
          .value;
      return userId;
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<String?> attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      return session.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
  }
  
  // todo: Verify how to implement "always remember device" on login. 
  Future<String?> login({
    required String username,
    required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username.trim(),
        password: password.trim(),
      );

      return result.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
  }

  // todo: verify how to 
  Future<bool> signUp({
    required String username,
    required String email, // make nullable, but one of email and phone number must be specified.
    required String password,
    required String phoneNumber, // make nullable, but one of email and phone number must be specified.
  }) async {
    if (!email.trim().isValidEmail()){
      throw InvalidParameterException("$email is not a valid email-adress.");
    }
    if (!phoneNumber.trim().isValidPhoneNumber()){
      throw InvalidParameterException("$email is not a valid email-adress.");
    }

    final options =
        CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: email.trim(),
          CognitoUserAttributeKey.phoneNumber: phoneNumber.trim(),
          });
    try {
      final result = await Amplify.Auth.signUp(
        username: username.trim(),
        password: password.trim(),
        options: options,
      );
      return result.isSignUpComplete;
    } on AuthException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Future<bool> confirmSignUp({
    required String username,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username.trim(),
        confirmationCode: confirmationCode.trim(),
      );
      return result.isSignUpComplete;
    } on AuthException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  // todo: Verify how to implement "forgetting device" on sign out.
  Future<bool> signOut() async {
    try {
      await Amplify.Auth.signOut(options: const SignOutOptions(globalSignOut: true));
      return true;
    } catch (e) {
      debugPrint("Error on sign out:\n" + e.toString());
      return false;
    }
  }
}

extension EmailValidator on String {
  
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

