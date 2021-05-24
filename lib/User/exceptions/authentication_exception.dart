class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({this.message = 'A ocurrido un error'});
}
