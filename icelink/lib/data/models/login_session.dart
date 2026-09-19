import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../../core/constants/app_constants.dart';
import 'login_request.dart';

class LoginSession {
  LoginSession({
    required this.name,
    required this.randomSalt,
    required this.token,
  });

  factory LoginSession.create(String rawName) {
    final name = rawName.trim();
    final randomSalt =
        Random().nextInt(AppConstants.tokenRandomMax) +
        AppConstants.tokenRandomMin;
    final source = '$name$randomSalt';
    final token = sha256.convert(utf8.encode(source)).toString();

    return LoginSession(name: name, randomSalt: randomSalt, token: token);
  }

  final String name;
  final int randomSalt;
  final String token;

  LoginRequest toRequest() {
    return LoginRequest(name: name, token: token);
  }
}
