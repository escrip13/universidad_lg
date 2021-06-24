import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Noticias/Exeption/exeption.dart';
import 'package:universidad_lg/Noticias/models/noticias_model.dart';
import '../../constants.dart';

abstract class NoticiasService {
  Future<Noticias> getNoticiasData({String userid, String token});
}

class IsNoticiasService extends NoticiasService {
  @override
  Future<Noticias> getNoticiasData({String userid, String token}) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/noticias'),
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
        Noticias noticiasJson = Noticias.fromJson(json.decode(response.body));
        return noticiasJson;
      } else {
        throw NoticiasExeption(message: _request['status']['message']);
      }
    } else {
      throw NoticiasExeption(message: 'ocurrio un problema de conexion');
    }
  }
}
