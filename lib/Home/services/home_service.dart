import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Home/models/models.dart';
import '../../constants.dart';

class HomeService {
  Future<List> servicegetHomeContent(String userid, String token) async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/load-home'),
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
        HomeCarrucel.fromJson(json.decode(response.body));

        // print(carrucel);

        // HomeNoticias noticias =
        //     HomeNoticias.fromJson(json.decode(response.body));
        // List home = [];

        // home.add(carrucel);
        // home.add(noticias);
        return null;
      } else {
        // throw HomeException(message: _request['status']['message']);
      }

      // throw AuthenticationException(message: 'Wrong username or password');
    } else {
      // throw HomeException(message: 'ocurrio un problema de conexion');
    }
  }
}
