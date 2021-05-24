import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyUserId = 'userId';
  static const _keyToken = 'tokenLogin';
  static const _keyUsername = 'username';
  static const _keyNombre = 'nombre';
  static const _keyEmail = 'email';
  static const _keyDocumento = 'documento';
  static const _keyCelular = 'celular';
  static const _keyEmpresa = 'celular';
  static const _keyCargo = 'cargo';
  static const _keyMensaje = 'mensaje';
  static const _keyisLogin = 'isLogin';

  //  UserId

  static Future setUserId(String login) async =>
      await _storage.write(key: _keyUserId, value: login);

  static Future<String> getUserId() async =>
      await _storage.read(key: _keyUserId);

// token

  static Future setLoginToken(String login) async =>
      await _storage.write(key: _keyToken, value: login);

  static Future<String> getLoginToken() async =>
      await _storage.read(key: _keyToken);

// setLoginCodigo

  static Future setLoginCodigo(String login) async =>
      await _storage.write(key: _keyToken, value: login);

  static Future<String> getLoginCodigo() async =>
      await _storage.read(key: _keyToken);

// username

  static Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);

  static Future<String> getUsername() async =>
      await _storage.read(key: _keyUsername);

  // nomebre

  static Future setNombre(String username) async =>
      await _storage.write(key: _keyNombre, value: username);

  static Future<String> getNombre() async =>
      await _storage.read(key: _keyNombre);

  // Email

  static Future setEmail(String username) async =>
      await _storage.write(key: _keyEmail, value: username);

  static Future<String> getEmail() async => await _storage.read(key: _keyEmail);

  // _Documento

  static Future setDocumento(String username) async =>
      await _storage.write(key: _keyDocumento, value: username);

  static Future<String> getDocumento() async =>
      await _storage.read(key: _keyDocumento);

// _Celular

  static Future setCelular(String username) async =>
      await _storage.write(key: _keyCelular, value: username);

  static Future<String> getCelular() async =>
      await _storage.read(key: _keyCelular);

// _Empresa

  static Future setEmpresa(String username) async =>
      await _storage.write(key: _keyEmpresa, value: username);

  static Future<String> getEmpresa() async =>
      await _storage.read(key: _keyEmpresa);

  // Cargo

  static Future setCargo(String username) async =>
      await _storage.write(key: _keyCargo, value: username);

  static Future<String> getCargo() async => await _storage.read(key: _keyCargo);

  // _keyMensaje

  static Future setMensaje(String username) async =>
      await _storage.write(key: _keyMensaje, value: username);

  static Future<String> getMensaje() async =>
      await _storage.read(key: _keyMensaje);

  // _key
  static Future setIslogin(String isLogin) async =>
      await _storage.write(key: _keyisLogin, value: isLogin);

  static Future<String> getIslogin() async =>
      await _storage.read(key: _keyisLogin);
}
