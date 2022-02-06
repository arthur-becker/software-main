import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/services/auth/auth_credentials.dart';
import 'package:mobile_app/services/auth/auth_cubit.dart';
import 'package:mobile_app/services/auth/auth_repository.dart';
import 'package:mobile_app/services/auth/form_submission_status.dart';
import 'package:mobile_app/services/auth/login/login_event.dart';
import 'package:mobile_app/services/auth/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  LoginBloc({required this.authRepo, required this.authCubit}) : super(LoginState()){
    on<LoginEvent>(_mapEventToState);
  }

  void _mapEventToState(LoginEvent event, Emitter<LoginState> emit) async {
    // Username updated
    if (event is LoginUsernameChanged) {
      emit(state.copyWith(userName: event.userName));

      // Password updated
    } else if (event is LoginPasswordChanged) {
      emit(state.copyWith(password: event.password));

      // Form submitted
    } else if (event is LoginSubmitted) {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        final userId = await authRepo.login(
          username: state.userName,
          password: state.password,
        );
        emit(state.copyWith(formStatus: SubmissionSuccess()));

        authCubit.launchSession(AuthCredentials(
          userName: state.userName,
          password: state.password,
          userId: userId,
        ));
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
      }
    }
  }
}