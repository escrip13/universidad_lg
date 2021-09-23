import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universidad_lg/Home/models/home_model.dart';
import 'package:universidad_lg/User/exceptions/authentication_exception.dart';
import 'package:universidad_lg/User/pages/login_page.dart';

import '../../constants.dart';

class HomeService {
  Future<Home> servicegetHomeContent(String userid, String token) async {
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
        Home homeFJ = Home.fromJson(json.decode(response.body));
        return homeFJ;
      } else {
        throw _request['status']['message'];
      }
    } else {
      throw AuthenticationException(message: 'Sin internet');
    }
  }
}
