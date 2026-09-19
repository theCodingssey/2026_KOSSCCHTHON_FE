import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionStorageService {
  SessionStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _userKeyKey = 'icelink.user_key';

  final FlutterSecureStorage _storage;

  Future<String?> readUserKey() {
    return _storage.read(key: _userKeyKey);
  }

  Future<void> saveUserKey(String userKey) {
    return _storage.write(key: _userKeyKey, value: userKey);
  }

  Future<void> clearUserKey() {
    return _storage.delete(key: _userKeyKey);
  }
}
