import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:desafio_mobile/login/login.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapEmailChangedToState(
    LoginEmailChanged event,
    LoginState state,
  ) {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([state.password, email]),
    );
  }

  LoginState _mapPasswordChangedToState(
    LoginPasswordChanged event,
    LoginState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.email]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    LoginSubmitted event,
    LoginState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository.logIn(
          email: state.email.value,
          password: state.password.value,
        );

        var user = FirebaseAuth.instance.currentUser!;

        FirebaseAnalytics().logEvent(
          name: 'login_success',
          parameters: {
            'uid': user.uid,
            'email': user.email,
          },
        );

        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on AuthenticationException catch (e) {
        FirebaseCrashlytics.instance
            .setCustomKey('authentication_exception', e.message);

        yield state.copyWith(
          status: FormzStatus.submissionFailure,
          errorLoginMessage: e.message,
        );
      } on Exception catch (e) {
        FirebaseCrashlytics.instance
            .setCustomKey('login_attempt_exception', e.toString());
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
