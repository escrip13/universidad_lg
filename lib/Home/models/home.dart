// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:universidad_lg/User/services/secure_storage.dart';

// class User {
//   final String userId;
//   final String name;
//   final String email;
//   final String username;
//   final String documento;
//   final String celular;
//   final String empresa;
//   final String cargo;
//   final String mensaje;
//   final String token;
//   final int codigo;
//   final int isLogin;

//   User({
//     Key key,
//     @required this.name,
//     @required this.email,
//     this.token,
//     this.userId,
//     this.username,
//     this.documento,
//     this.celular,
//     this.empresa,
//     this.cargo,
//     this.mensaje,
//     this.codigo,
//     this.isLogin,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       userId: json['status']['dataUser']['userId'],
//       token: json['status']['dataUser']['token'],
//       codigo: json['status']['dataUser']['codigo'],
//       email: json['status']['dataUser']['email'],
//       username: json['status']['dataUser']['username'],
//       name: json['status']['dataUser']['nombre'],
//       documento: json['status']['dataUser']['documento'],
//       celular: json['status']['dataUser']['celular'],
//       empresa: json['status']['dataUser']['empresa'],
//       cargo: json['status']['dataUser']['cargo'],
//       mensaje: json['status']['dataUser']['mensaje'],
//     );
//   }
//   @override
//   String toString() => 'User { name: $name, email: $email, token: $token}';
// }

// class UserStorage {
//   final User user;

//   UserStorage({
//     Key key,
//     this.user,
//   });

//   Future createUserStorage() async {
//     await UserSecureStorage.setUserId(user.userId);
//     await UserSecureStorage.setLoginToken(user.token);
//     await UserSecureStorage.setLoginCodigo(user.codigo.toString());
//     await UserSecureStorage.setEmail(user.email);
//     await UserSecureStorage.setUsername(user.username);
//     await UserSecureStorage.setNombre(user.name);
//     await UserSecureStorage.setDocumento(user.documento);
//     await UserSecureStorage.setCelular(user.celular);
//     await UserSecureStorage.setEmpresa(user.empresa);
//     await UserSecureStorage.setCargo(user.cargo);
//     await UserSecureStorage.setMensaje(user.mensaje);
//   }

//   Future destroyUserStorage() async {
//     await UserSecureStorage.setUserId(null);
//     await UserSecureStorage.setLoginToken(null);
//     await UserSecureStorage.setLoginCodigo(null);
//     await UserSecureStorage.setEmail(null);
//     await UserSecureStorage.setUsername(null);
//     await UserSecureStorage.setNombre(null);
//     await UserSecureStorage.setDocumento(null);
//     await UserSecureStorage.setCelular(null);
//     await UserSecureStorage.setEmpresa(null);
//     await UserSecureStorage.setCargo(null);
//     await UserSecureStorage.setMensaje(null);
//     await UserSecureStorage.setIslogin(null);
//     return true;
//   }
// }
