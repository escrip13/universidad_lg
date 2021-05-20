import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyLoginSession = 'loginSession';

  static Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);

  static Future<String> getUsername() async =>
      await _storage.read(key: _keyUsername);

  static Future setLoginSession(String login) async =>
      await _storage.write(key: _keyLoginSession, value: login);

  static Future<String> getLoginSession() async =>
      await _storage.read(key: _keyLoginSession);
}
