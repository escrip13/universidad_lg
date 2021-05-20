import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:universidad_lg/User/model/user.dart';
import 'package:universidad_lg/User/repository/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/User/repository/secure_storage.dart';

class UserBloc implements Bloc {
  Future<http.Response> signIn({String correo: '', password: ''}) {
    User user = User(correo: correo, password: password);
    AuthRepository authRepository = AuthRepository(user: user);
    return authRepository.signInWithDrupal();
  }

  // Stream<SecureStorage> loger = SecureStorage().readSecureData('is_login');

  // bool get authStatus {
  //   AuthRepository authRepository = AuthRepository();

  //   return true;
  // }

  @override
  void dispose() {}
}
