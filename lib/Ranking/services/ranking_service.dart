import 'dart:convert';

import 'package:universidad_lg/Ranking/exeption/ranking_exeption.dart';
import 'package:universidad_lg/Ranking/models/ranking_model.dart';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/constants.dart';

abstract class RankingService {
  Future<Ranking> getRankingService({String uid, String token});
}

class IsRankingService extends RankingService {
  @override
  Future<Ranking> getRankingService({String uid, String token}) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/ranking'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': uid,
        'token': token,
      }),
    );

    if (response.statusCode == 200) {
      final _request = json.decode(response.body);

      if (_request['status']['type'] != 'error') {
        Ranking streaming = Ranking.fromJson(json.decode(response.body));
        return streaming;
      } else {
        throw RankingExeption(message: _request['status']['message']);
      }
    } else {
      throw RankingExeption(message: 'ocurrio un problema de conexion');
    }
  }
}
