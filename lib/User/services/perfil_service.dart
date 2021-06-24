import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/User/exceptions/perfil_exception.dart';
import 'package:universidad_lg/User/models/perfil.dart';
import 'package:universidad_lg/User/services/secure_storage.dart';
import '../../constants.dart';

abstract class PerfilService {
  Future<Perfil> getPerfil(String uid, String token);
  Future<String> sentPerfil(
      String uid, String token, String documento, String celular, String foto);
}

class IsPerfilService extends PerfilService {
  @override
  Future<Perfil> getPerfil(String uid, String token) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/perfil'),
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
        Perfil perfil = Perfil.fromJson(json.decode(response.body));
        return perfil;
      } else {
        throw PerfinException(message: _request['status']['message']);
      }
    } else {
      throw PerfinException(message: 'ocurrio un problema de conexion');
    }
  }

  @override
  Future<String> sentPerfil(String uid, String token, String documento,
      String celular, String foto) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/perfi/save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': uid,
        'token': token,
        'imagen': foto,
        'documento': documento,
        'celular': celular,
      }),
    );

    if (response.statusCode == 200) {
      final _request = json.decode(response.body);
      // print(_request);
      if (_request['status']['type'] != 'error') {
        UserSecureStorage.setDocumento(documento);
        UserSecureStorage.setCelular(celular);

        return _request['status']['message'];
      } else {
        throw PerfinException(message: _request['status']['message']);
      }
    } else {
      throw PerfinException(message: 'ocurrio un problema de conexion');
    }
  }
}
