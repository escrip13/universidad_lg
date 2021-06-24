import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:universidad_lg/Entrenamiento/blocs/entrenamiento_bloc.dart';
import 'package:universidad_lg/Entrenamiento/models/respuestastestsalida_model.dart';
import 'package:universidad_lg/User/models/models.dart';
import '../../constants.dart';

class RespuestasTestSalidaPage extends StatelessWidget {
  final User user;
  final String evaluacion;

  const RespuestasTestSalidaPage({Key key, this.user, this.evaluacion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PREGUNTAS Y RESPUETAS',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: mainColor,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: _ContentData(
          user: user,
          evaluacion: evaluacion,
        ),
      ),
    );
  }
}

class _ContentData extends StatefulWidget {
  final User user;
  final evaluacion;

  const _ContentData({Key key, this.user, this.evaluacion}) : super(key: key);

  @override
  State<StatefulWidget> createState() => __ContentData();
}

class __ContentData extends State<_ContentData> {
  RespuestasTestSalida data;
  EntrenamientoBloc entrenamientoBloc = EntrenamientoBloc();

  bool load = false;

  void _onLoad() {
    if (mounted) {
      setState(() {
        load = true;
      });
    }
  }

  void loadDataRespuesta() async {
    await entrenamientoBloc
        .respuestasTestSalida(
            token: widget.user.token,
            uid: widget.user.userId,
            curso: widget.evaluacion)
        .then((value) {
      _onLoad();
      data = value;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDataRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    int cont = 1;
    // TODO: implement build
    if (load) {
      return SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              for (var item in data.status.respuetas.items)
                ItemRespuetas(item, cont++),
            ],
          ),
        ),
      );
    }

    return Center(
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }
}

class ItemRespuetas extends StatelessWidget {
  final Item item;
  final int cont;

  ItemRespuetas(this.item, this.cont);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pregunta  $cont',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: mainColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            item.pregunta,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var rs in item.respuesta)
                  itemRespueta(
                    item: rs,
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class itemRespueta extends StatelessWidget {
  final Respuesta item;

  const itemRespueta({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (item.estado == 0) {
      return Text(
        item.respuesta,
        style: TextStyle(color: Colors.red),
      );
    } else if (item.estado == 1) {
      return Text(
        item.respuesta,
        style: TextStyle(color: Colors.green),
      );
    } else {
      return Text(
        item.respuesta,
      );
    }
  }
}
