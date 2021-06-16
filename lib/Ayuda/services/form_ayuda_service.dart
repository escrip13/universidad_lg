import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Ayuda/bloc/ayuda_bloc.dart';
import 'package:universidad_lg/constants.dart';

abstract class FormAyudaService {
  Future<String> sendFormAyuda(
      {String tema, String pregunta, String user, String token});
}

class IsformAyuadaService extends FormAyudaService {
  @override
  Future<String> sendFormAyuda(
      {String tema, String pregunta, String user, String token}) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/ayuda/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'userId': user,
          'token': token,
          'tema': tema,
          'pregunta': pregunta
        },
      ),
    );

    if (response.statusCode == 200) {
      final _request = json.decode(response.body);
      if (_request['status']['type'] != 'error') {
        return _request['status']['message'];
      } else {
        throw ErrorAyuda(_request['status']['message']);
      }
    } else {
      throw ErrorAyuda('error en coneccio ');
    }
  }
}
