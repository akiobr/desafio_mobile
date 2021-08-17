part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.errorLoginMessage = 'Falha na autenticação',
  });

  final FormzStatus status;
  final Email email;
  final Password password;
  final String errorLoginMessage;

  LoginState copyWith({
    FormzStatus? status,
    Email? email,
    Password? password,
    String? errorLoginMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorLoginMessage: errorLoginMessage ?? this.errorLoginMessage,
    );
  }

  @override
  List<Object> get props => [status, email, password];
}
