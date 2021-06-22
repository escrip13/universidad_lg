import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Biblioteca/exeption/exeption.dart';
import 'package:universidad_lg/Biblioteca/models/biblioteca_model.dart';
import 'package:universidad_lg/constants.dart';

abstract class BibliotecaService {
  Future<Biblioteca> getBiblioteca({String userid, String token});
}

class IsBibliotecaService extends BibliotecaService {
  @override
  Future<Biblioteca> getBiblioteca({String userid, String token}) async {
    // TODO: implement getBiblioteca

    final response = await http.post(
      Uri.https(baseUrl, 'app/biblioteca'),
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
        Biblioteca streaming = Biblioteca.fromJson(json.decode(response.body));
        return streaming;
      } else {
        throw BibliotecaExeption(message: _request['status']['message']);
      }
    } else {
      throw BibliotecaExeption(message: 'ocurrio un problema de conexion');
    }
  }
}
