import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/services/auth/auth_cubit.dart';
import 'package:mobile_app/services/auth/auth_repository.dart';
import 'package:mobile_app/services/auth/form_submission_status.dart';

import 'confirmation_event.dart';
import 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  ConfirmationBloc({
    required this.authRepo,
    required this.authCubit,
  }) : super(ConfirmationState()) {
    on<ConfirmationEvent>(_mapEventToState);
  }

  void _mapEventToState(ConfirmationEvent event, Emitter<ConfirmationState> emit) async {
    // Confirmation code updated
    if (event is ConfirmationCodeChanged) {
      emit(state.copyWith(code: event.code));

      // Form submitted
    } else if (event is ConfirmationSubmitted) {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        await authRepo.confirmSignUp(
          username: authCubit.credentials.userName,
          confirmationCode: state.code,
        );

        emit(state.copyWith(formStatus: SubmissionSuccess()));

        final credentials = authCubit.credentials;
        final userId = await authRepo.login(
          username: credentials.userName,
          password: credentials.password,
        );
        credentials.userId = userId;

        authCubit.launchSession(credentials);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
      }
    }
  }
}