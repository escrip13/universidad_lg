import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/User/services/secure_storage.dart';
import '../../constants.dart';
import '../exceptions/exceptions.dart';
import '../models/models.dart';

abstract class AuthenticationService {
  Future<User> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class IsAuthenticationService extends AuthenticationService {
  @override
  Future<User> getCurrentUser() async {
    final islogin = await UserSecureStorage.getIslogin();

    if (islogin != null) {
      final nombre = await UserSecureStorage.getNombre();
      final email = await UserSecureStorage.getEmail();
      final token = await UserSecureStorage.getLoginToken();
      final uid = await UserSecureStorage.getUserId();

      final response = await http.post(
        Uri.https(baseUrl, 'app/validate-session'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': uid,
          'token': token,
        }),
      );
      // print(response.body);
      if (response.statusCode == 200) {
        final _request = json.decode(response.body);

        if (_request['status']['type'] != 'error') {
          return User(name: nombre, email: email, token: token, userId: uid);
        } else {
          return null;
          // throw AuthenticationException(message: _request['status']['message']);
        }
        // throw AuthenticationException(message: 'Wrong username or password');
      } else {
        throw AuthenticationException(
            message: 'ocurrio un problema de conexion');
      }
    }

    return null;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email.trim(),
        'password': password.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final _request = json.decode(response.body);

      if (_request['status']['type'] != 'error') {
        User user = User.fromJson(json.decode(response.body));
        UserStorage userStorage = UserStorage(user: user);
        await userStorage.createUserStorage();
        return user;
      } else {
        throw AuthenticationException(message: _request['status']['message']);
      }

      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      throw AuthenticationException(message: 'ocurrio un problema de conexion');
    }
  }

  @override
  Future<void> signOut() async {
    final token = await UserSecureStorage.getLoginToken();
    if (token != null) {
      UserStorage userStorage = UserStorage();
      return await userStorage.destroyUserStorage();
    }
    return null;
  }
}
