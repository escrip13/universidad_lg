import 'dart:convert';
import 'package:universidad_lg/User/model/user.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  User user;

  AuthRepository({
    this.user,
  });

  bool isloger = false;

  static const baseUrl = 'dev.licoreraencasa.com';

  Future<http.Response> signInWithDrupal() async {
    final response = await http.post(
      Uri.https(baseUrl, 'app/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': user.correo,
        'password': user.password,
      }),
    );

    print(response.statusCode);
    print(response.body);

    return response;

    //   if (response.statusCode == 201) {
    //   // If the server did return a 201 CREATED response,
    //   // then parse the JSON.

    //   return jsonDecode(response.body);
    // } else {
    //   // If the server did not return a 201 CREATED response,
    //   // then throw an exception.
    //   throw Exception('Failed to create album.');
    // }
  }

  bool isLoger() => true;
}
