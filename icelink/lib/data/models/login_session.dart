import 'login_request.dart';

class LoginSession {
  LoginSession({required this.name, this.userKey});

  factory LoginSession.create(String rawName) {
    final name = rawName.trim();

    return LoginSession(name: name);
  }

  final String name;
  final String? userKey;

  LoginRequest toRequest() {
    return LoginRequest(name: name);
  }
}
