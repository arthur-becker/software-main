import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/services/auth/auth_credentials.dart';
import 'package:mobile_app/services/auth/auth_repository.dart';
import 'package:mobile_app/structure/data_repository.dart';
import 'package:mobile_app/services/session/session_state.dart';

import 'package:mobile_app/models/User.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  final DataRepository dataRepo;

  SessionCubit({
    required this.authRepo,
    required this.dataRepo,
  }) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepo.attemptAutoLogin();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      User? user = await dataRepo.getUserById(userId);

      // Will assign generic firstName and lastName to user, 
      // in unlikely case of attemptAutoLogin() authenticating user, 
      // but no user returned returned by datastore query.
      user ??= await dataRepo.createUser(
          userId: userId,
          firstName: 'User-${UUID()}',
          lastName: '',
        );
      emit(Authenticated(user: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) async {
    try {
      if (credentials.userId == null){
        emit(Unauthenticated());
      }

      User? user = await dataRepo.getUserById(credentials.userId!);

      user ??= await dataRepo.createUser(
          userId: credentials.userId!,
          firstName: credentials.getFirstName(),
          lastName: credentials.getLastName(),
        );

      emit(Authenticated(user: user));
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}