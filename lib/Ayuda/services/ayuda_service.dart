import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Ayuda/exeption/ayuda_exeption.dart';
import 'package:universidad_lg/Ayuda/models/ayuda_model.dart';
import 'package:universidad_lg/constants.dart';

abstract class AyudaService {
  Future<Ayuda> getAyuda({String user, String token});
}

class IsAyudaService extends AyudaService {
  @override
  Future<Ayuda> getAyuda({String user, String token}) async {
    final response = await http.post(Uri.https(baseUrl, 'app/ayuda'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'userId': user,
            'token': token,
          },
        ));

    if (response.statusCode == 200) {
      final _request = json.decode(response.body);

      if (_request['status']['type'] != 'error') {
        return Ayuda.fromJson(json.decode(response.body));
      } else {
        throw AyudaExeption(mesaje: _request['status']['message']);
      }
    } else {
      throw AyudaExeption(mesaje: 'ocurrio un problema de conexion');
    }
  }
}
