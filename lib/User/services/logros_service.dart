import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/User/exceptions/logros_exception.dart';
import 'package:universidad_lg/User/models/logros.dart';
import '../../constants.dart';

abstract class LogrosService {
  Future<Logros> getLogros(String uid, String token);
}

class IsLogrosService extends LogrosService {
  @override
  Future<Logros> getLogros(String uid, String token) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/logros'),
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
        Logros logros = Logros.fromJson(json.decode(response.body));
        return logros;
      } else {
        throw LogrosException(message: _request['status']['message']);
      }
    } else {
      throw LogrosException(message: 'ocurrio un problema de conexion');
    }
  }
}
