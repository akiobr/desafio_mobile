class AuthenticationException implements Exception {
  AuthenticationException({required this.message}) : super();

  final String message;

  @override
  String toString() {
    return 'AuthenticationException: $message';
  }
}
