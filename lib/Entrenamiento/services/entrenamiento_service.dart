import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Entrenamiento/models/models.dart';
import '../../constants.dart';

class EntrenamientoService {
  Future<Entrenamiento> servicegetEntrenamientoContent(
      String userid, String token) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/entrenamiento'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userid,
        'token': token,
      }),
    );

    if (response.statusCode == 200) {
      final _request = json.decode(response.body);
      if (_request['status']['type'] != 'error') {
        Entrenamiento entrenaminentoFJ =
            Entrenamiento.fromJson(json.decode(response.body));
        return entrenaminentoFJ;
      } else {
        throw null;
      }

      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      // throw HomeException(message: 'ocurrio un problema de conexion');
    }
  }
}
