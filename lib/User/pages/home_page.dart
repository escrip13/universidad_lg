// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:universidad_lg/User/blocs/authentication/authentication_bloc.dart';
// import 'package:universidad_lg/User/blocs/authentication/authentication_event.dart';

// import '../models/models.dart';

// class HomePage extends StatelessWidget {
//   final User user;

//   const HomePage({Key key, this.user}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final authBloc = BlocProvider.of<AuthenticationBloc>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Page'),
//       ),
//       body: SafeArea(
//         minimum: const EdgeInsets.all(16),
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Text(
//                 'Welcome, ${user.name}',
//                 style: TextStyle(fontSize: 24),
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               TextButton(
//                 style: TextButton.styleFrom(),
//                 child: Text('Logout'),
//                 onPressed: () {
//                   authBloc.add(UserLoggedOut());
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
