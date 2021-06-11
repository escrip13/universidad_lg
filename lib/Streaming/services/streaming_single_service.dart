import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Streaming/Exeption/exeption.dart';

import '../../constants.dart';

import 'package:universidad_lg/Streaming/models/streaming_single_model.dart';

abstract class ServiceStreamingSingle {
  Future<SingleStreaming> getSteamingSingleData(
      {String userid, String token, String nid});
}

class IsServiceStreamingSingle extends ServiceStreamingSingle {
  @override
  Future<SingleStreaming> getSteamingSingleData(
      {String userid, String token, String nid}) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/streaming/detalle'),
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
        SingleStreaming streaming =
            SingleStreaming.fromJson(json.decode(response.body));
        return streaming;
      } else {
        throw StreamingExeption(message: _request['status']['message']);
      }
    } else {
      throw StreamingExeption(message: 'ocurrio un problema de conexion');
    }
  }
}
