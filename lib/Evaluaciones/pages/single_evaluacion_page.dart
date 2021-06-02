import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Evaluaciones/blocs/evaluacion_bloc.dart';
import 'package:universidad_lg/Evaluaciones/models/single_evaluacion_model.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/authentication/authentication.dart';
import 'package:universidad_lg/User/models/models.dart';
import 'package:universidad_lg/User/pages/login_page.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';
import 'package:cool_stepper/cool_stepper.dart';

import '../../constants.dart';

class SingleEvaluacionPage extends StatelessWidget {
  final User user;
  final String nid;
  const SingleEvaluacionPage({
    Key key,
    @required this.user,
    @required this.nid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Center(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            user: user,
                          )));
            },
            child: Image(
              image: AssetImage('assets/img/new_logo.png'),
              height: 35,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(Icons.person),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      drawer: DrawerMenuLeft(
        user: user,
        currenPage: 'evaluaciones',
      ),
      endDrawer: DrawerMenuRight(),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page

            return _SingleEvaluacionContent(user: state.user, nid: nid);
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}

class _SingleEvaluacionContent extends StatefulWidget {
  User user;
  String nid;
  _SingleEvaluacionContent({this.user, this.nid});
  @override
  __SingleEvaluacionContentState createState() =>
      __SingleEvaluacionContentState();
}

class __SingleEvaluacionContentState extends State<_SingleEvaluacionContent> {
  SingleEvaluacion evaluacionInfo;
  bool load = false;
  EvaluacionBloc evalacioonBloc = EvaluacionBloc();

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
      });
    }
  }

  void loadData() {
    evalacioonBloc
        .getSingleEvaluaionesContent(
            token: widget.user.token, uid: widget.user.userId, nid: widget.nid)
        .then((value) {
      _onLoad();
      evaluacionInfo = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (load) {
      return Container(
        // padding: EdgeInsets.all(0),
        child: _ContentSingleEvaluacion(
          evaluacionInfo: evaluacionInfo.status.preguntas,
        ),
      );
    }

    loadData();

    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

class _ContentSingleEvaluacion extends StatefulWidget {
  final List<Pregunta> evaluacionInfo;
  _ContentSingleEvaluacion({this.evaluacionInfo});
  @override
  __ContentSingleEvaluacionState createState() =>
      __ContentSingleEvaluacionState();
}

class __ContentSingleEvaluacionState extends State<_ContentSingleEvaluacion> {
  String selectedRole = 'Writer';

  @override
  Widget build(BuildContext context) {
    int cont = 1;

    final List<CoolStep> steps = [];
    for (var item in widget.evaluacionInfo) {
      // List<Respuesta> repustas = item.respuestas;
      List<Respuesta> respuesta = item.respuestas;

      steps.add(CoolStep(
        title: 'Pregunta $cont',
        subtitle: item.texto,
        content: Container(
          child: Column(
            children: <Widget>[
              for (var rs in respuesta)
                _buildSelector(
                    name: rs.texto,
                    value: rs.delta.toString(),
                    context: context),
            ],
          ),
        ),
        validation: () {
          return null;
        },
      ));
      cont++;
    }

    return Container(
      child: CoolStepper(
        showErrorSnackbar: false,
        onCompleted: () {
          print('Steps completed!');
        },
        steps: steps,
        config: CoolStepperConfig(
          backText: 'ANTERIOR',
          nextText: 'SIGUIENTE',
          stepText: '',
          iconColor: mainColor,
          ofText: 'DE',
          headerColor: mainColor,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
          subtitleTextStyle: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildSelector({
    BuildContext context,
    @required String name,
    @required String value,
  }) {
    final isActive = name == selectedRole;

    return RadioListTile(
      value: value,
      activeColor: mainColor,
      groupValue: selectedRole,
      onChanged: (v) {
        setState(() {
          selectedRole = v;
        });
      },
      title: Text(
        name,
        style: TextStyle(
          color: isActive ? Colors.white : null,
        ),
      ),
    );
  }
}
