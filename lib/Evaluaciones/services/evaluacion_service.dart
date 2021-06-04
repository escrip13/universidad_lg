import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Evaluaciones/models/evaluacion_model.dart';
import 'package:universidad_lg/Evaluaciones/models/send_evaluacion.dart';
import 'package:universidad_lg/Evaluaciones/models/single_evaluacion_model.dart';

import '../../constants.dart';

class EvaluacionService {
  Future<Evaluacion> servicegetEvaluacionesContent(
      String userid, String token) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/evaluaciones'),
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
        Evaluacion evacionesFJ =
            Evaluacion.fromJson(json.decode(response.body));
        return evacionesFJ;
      } else {
        throw ('error');
      }

      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      throw ('error');
    }
  }

  Future<SingleEvaluacion> servicegetSingleEvaluacionesContent(
      String userid, String token, String nid) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/evaluaciones/detalle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'userId': userid, 'token': token, 'eva_nid': nid}),
    );

    if (response.statusCode == 200) {
      final _request = json.decode(response.body);
      if (_request['status']['type'] != 'error') {
        SingleEvaluacion singleEvacionesFJ =
            SingleEvaluacion.fromJson(json.decode(response.body));

        return singleEvacionesFJ;
      } else {
        throw _request['status']['message'];
      }
      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      throw ('error');
    }
  }

  ////   enviar evaluacion

  Future<SendEvaluacion> sendEvaluacion(
      String userid, String token, String nid, Map data) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/evaluaciones/detalle/save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userid,
        'token': token,
        'eva_nid': nid,
        'respuestas': data
      }),
    );

    if (response.statusCode == 200) {
      final _request = json.decode(response.body);
      if (_request['status']['type'] != 'error') {
        SendEvaluacion resEvacionesFJ =
            SendEvaluacion.fromJson(json.decode(response.body));

        return resEvacionesFJ;
      } else {
        throw _request['status']['message'];
      }
      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      throw ('error');
    }
  }
}
