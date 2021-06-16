import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Entrenamiento/models/entrenamiento_model.dart';
import 'package:universidad_lg/Entrenamiento/models/cursopreview_model.dart';
import 'package:universidad_lg/Entrenamiento/models/leccion_model.dart';
import 'package:universidad_lg/Entrenamiento/models/testentrada_model.dart';
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
        print('API Entrenamiento');
        Entrenamiento entrenamientoJson =
            Entrenamiento.fromJson(json.decode(response.body));
        return entrenamientoJson;
      } else {
        throw null;
      }

      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      // throw HomeException(message: 'ocurrio un problema de conexion');
    }
  }

  Future<CursoPreview> serviceGetCursoPreviewContent(
      String userid, String token, String curso) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/entrenamiento/curso'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userid,
        'token': token,
        'curso': curso,
      }),
    );

    // Validamos response
    if (response.statusCode == 200) {
      final _request = json.decode(response.body);
      if (_request['status']['type'] != 'error') {
        print('API Curso Preview');
        CursoPreview cursoPreviewJson =
            CursoPreview.fromJson(json.decode(response.body));
        return cursoPreviewJson;
      } else {
        throw null;
      }

      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      // throw HomeException(message: 'ocurrio un problema de conexion');
    }
  }

  Future<TestEntrada> serviceGetTestEntradaContent(
      String userid, String token, String curso, String leccion) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/entrenamiento/curso/test-entrada'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userid,
        'token': token,
        'curso': curso,
        'leccion_id': leccion
      }),
    );

    // Validamos response
    if (response.statusCode == 200) {
      final _request = json.decode(response.body);
      if (_request['status']['type'] != 'error') {
        print('API Test Entrada');
        TestEntrada testEntradaJson =
            TestEntrada.fromJson(json.decode(response.body));
        return testEntradaJson;
      } else {
        throw null;
      }

      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      // throw HomeException(message: 'ocurrio un problema de conexion');
    }
  }

  Future<Leccion> serviceGetLeccionContent(
      String userid, String token, String curso, String leccion) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/entrenamiento/curso/ver'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userid,
        'token': token,
        'curso': curso,
        'leccion_id': leccion
      }),
    );

    // Validamos response
    if (response.statusCode == 200) {
      final _request = json.decode(response.body);
      if (_request['status']['type'] != 'error') {
        print('API Leccion');
        Leccion leccionJson = Leccion.fromJson(json.decode(response.body));
        return leccionJson;
      } else {
        throw null;
      }

      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      // throw HomeException(message: 'ocurrio un problema de conexion');
      print('Error Leccion');
    }
  }
}
