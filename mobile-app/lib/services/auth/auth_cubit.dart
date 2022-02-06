import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/services/auth/auth_credentials.dart';
import 'package:mobile_app/services/session/session_cubit.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;

  AuthCubit({required this.sessionCubit}) : super(AuthState.login);

  late AuthCredentials credentials;

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);
  void showConfirmSignUp({
    required String userName,
    required String password,
    String? email,
  }) {
    credentials = AuthCredentials(
      userName: userName,
      email: email,
      password: password,
    );
    emit(AuthState.confirmSignUp);
  }

  void launchSession(AuthCredentials credentials) =>
      sessionCubit.showSession(credentials);
}