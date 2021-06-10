import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Streaming/Exeption/exeption.dart';
import 'package:universidad_lg/Streaming/models/streaming_model.dart';

import '../../constants.dart';

abstract class StreamingService {
  Future<Streaming> getSteamingData({String userid, String token});
}

class IsStreamingService extends StreamingService {
  @override
  Future<Streaming> getSteamingData({String userid, String token}) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/streaming'),
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
        Streaming streaming = Streaming.fromJson(json.decode(response.body));
        return streaming;
      } else {
        throw StreamingExeption(message: _request['status']['message']);
      }
    } else {
      throw StreamingExeption(message: 'ocurrio un problema de conexion');
    }
  }
}
