import 'dart:async';
import 'services/services.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    await AuthenticationService().authenticate(
      email: email,
      password: password,
    );

    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> logOut() async {
    await AuthenticationService().signOut();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
