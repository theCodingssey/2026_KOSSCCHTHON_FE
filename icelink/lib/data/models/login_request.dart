class LoginRequest {
  const LoginRequest({required this.name, required this.token});

  final String name;
  final String token;

  Map<String, dynamic> toJson() {
    return {'name': name, 'token': token};
  }
}
