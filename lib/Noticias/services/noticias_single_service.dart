import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Noticias/Exeption/exeption.dart';

import '../../constants.dart';

import 'package:universidad_lg/Noticias/models/noticias_single_model.dart';

abstract class ServiceNoticiasSingle {
  Future<SingleNoticia> getSteamingSingleData(
      {String userid, String token, String nid});
}

class IsServiceNoticiasSingle extends ServiceNoticiasSingle {
  @override
  Future<SingleNoticia> getSteamingSingleData(
      {String userid, String token, String nid}) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/noticias/detalle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userid,
        'token': token,
        'nid': nid,
      }),
    );

    if (response.statusCode == 200) {
      final _request = jsonDecode(response.body);

      if (_request['status']['type'] != 'error') {
        SingleNoticia streaming =
            SingleNoticia.fromJson(json.decode(response.body));
        return streaming;
      } else {
        throw NoticiasExeption(message: _request['status']['message']);
      }
    } else {
      throw NoticiasExeption(message: 'ocurrio un problema de conexion');
    }
  }
}
