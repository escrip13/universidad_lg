import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universidad_lg/Home/pages/home_page.dart';
import 'package:universidad_lg/User/blocs/perfil/perfil_bloc.dart';
import 'package:universidad_lg/User/models/perfil.dart';
import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/User/services/perfil_service.dart';
import 'package:universidad_lg/User/services/secure_storage.dart';
import 'package:universidad_lg/widgets/background_image.dart';
import 'package:universidad_lg/widgets/buttom_main_navigator.dart';
import 'package:universidad_lg/widgets/drawer_menu_left.dart';
import 'package:universidad_lg/widgets/drawer_menu_right.dart';
import 'package:validators/validators.dart' as validator;

import '../../constants.dart';

class PerfilPage extends StatelessWidget {
  final User user;

  const PerfilPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Center(
          child: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) {
                return HomePage(
                  user: user,
                );
              }), (route) => false);
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
      ),
      endDrawer: DrawerMenuRight(
        user: user,
        currenPage: 'perfil',
      ),
      body: BlocProvider<PerfilBloc>(
        create: (context) => PerfilBloc(service: IsPerfilService()),
        child: _ContentPerfilPage(user: user),
      ),
    );
  }
}

class _ContentPerfilPage extends StatefulWidget {
  final User user;

  const _ContentPerfilPage({Key key, this.user}) : super(key: key);

  @override
  __ContentPerfilPageState createState() => __ContentPerfilPageState();
}

class __ContentPerfilPageState extends State<_ContentPerfilPage> {
  Perfil data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getPerfil();
  }

  void _showResponse(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: mainColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: BlocListener<PerfilBloc, PerfilState>(
      listener: (context, state) {
        if (state is PerfilSend) {
          _showResponse(state.message);
        }
        if (state is ErrorPerfil) {
          _showResponse(state.message);
        }
      },
      child: BlocBuilder<PerfilBloc, PerfilState>(builder: (context, state) {
        if (state is PerfilSuccess) {
          data = state.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                BannerPerfil(imagen: state.data.status.data.imagen),
                ContentBody(
                  user: widget.user,
                  totalpuntos: state.data.status.data.totalpuntos,
                  oro: state.data.status.data.oro,
                  plata: state.data.status.data.plata,
                  bronce: state.data.status.data.bronce,
                ),
              ],
            ),
          );
        }

        if (state is ChangeImage) {
          return SingleChildScrollView(
            child: Column(
              children: [
                BannerPerfil(imagen: data.status.data.imagen),
                ContentBody(
                  user: widget.user,
                  totalpuntos: data.status.data.totalpuntos,
                  oro: data.status.data.oro,
                  plata: data.status.data.plata,
                  bronce: data.status.data.bronce,
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: mainColor,
          ),
        );
      }),
    ));
  }

  void _getPerfil() {
    final blocPerfil = BlocProvider.of<PerfilBloc>(context);
    blocPerfil.add(
        GetPerfilEvent(user: widget.user.userId, token: widget.user.token));
  }
}

class BannerPerfil extends StatefulWidget {
  final String imagen;

  const BannerPerfil({Key key, this.imagen}) : super(key: key);

  @override
  _BannerPerfilState createState() => _BannerPerfilState();
}

class _BannerPerfilState extends State<BannerPerfil> {
  final _picker = ImagePicker();
  String img;
  bool change = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          BacgroundImage(
            image: 'assets/img/back-perfil.png',
            height: null,
          ),
          if (change == false)
            InkWell(
              onTap: choose,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: widget.imagen,
                  placeholder: (context, url) => CircularProgressIndicator(
                    color: mainColor,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            )
          else
            InkWell(
              onTap: choose,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(File(img)),
              ),
            )
        ],
      ),
    );
  }

  void choose() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        img = image.path;
        change = true;
      });

      List<int> imageBytes = await image.readAsBytes();

      final blocPerfil = BlocProvider.of<PerfilBloc>(context);
      blocPerfil.add(SetImagePerfilEvent(base64Encode(imageBytes)));
    }
  }
}

class ContentBody extends StatelessWidget {
  final User user;
  final int totalpuntos;
  final int oro;
  final int plata;
  final int bronce;

  const ContentBody(
      {Key key, this.user, this.totalpuntos, this.oro, this.plata, this.bronce})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DETALLES DE PERFIL',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            user.name,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            user.email,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Puntos: $totalpuntos',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: Color(0xFFfbeb39),
                    size: 50.0,
                  ),
                  Text(
                    oro.toString(),
                  )
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: Color(0xFFe4e4e4),
                    size: 50.0,
                  ),
                  Text(
                    plata.toString(),
                  )
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: Color(0xFFf8ac2f),
                    size: 50.0,
                  ),
                  Text(
                    bronce.toString(),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          ButtomMain(
            text: 'RANKING',
            // onpress: StreamingSinglePage(
            //   user: user,
            //   nid: item.nid,
            // ),
          ),
          SizedBox(
            height: 40.0,
          ),
          FormPerfil(user: user),
        ],
      ),
    );
  }
}

class FormPerfil extends StatefulWidget {
  final User user;

  const FormPerfil({Key key, this.user}) : super(key: key);
  @override
  _FormPerfilState createState() => _FormPerfilState();
}

class _FormPerfilState extends State<FormPerfil> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _autoValidate = false;
  final _documentoController = TextEditingController();
  final _celularController = TextEditingController();
  String image = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data_form();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<PerfilBloc, PerfilState>(
      builder: (context, state) {
        if (state is ChangeImage) {
          image = state.path;
        }
        return Form(
          key: _key,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              TextFormField(
                enabled: false,
                style: TextStyle(color: Colors.black38),
                initialValue: widget.user.name,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: mainColor),
                  // hintText: '',
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                    ),
                  ),
                ),
                autocorrect: false,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black38),
                enabled: false,
                initialValue: widget.user.email,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: mainColor),
                  // hintText: '',
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                    ),
                  ),
                ),
                autocorrect: false,
              ),
              TextFormField(
                // initialValue: widget.user.documento,
                keyboardType: TextInputType.number,
                controller: _documentoController,
                decoration: InputDecoration(
                  labelText: 'Documento',
                  labelStyle: TextStyle(color: mainColor),
                  // hintText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                    ),
                  ),
                ),
                autocorrect: false,
                validator: (String value) {
                  if (validator.isNull(value)) {
                    return '*Campo Requerido';
                  }

                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                // initialValue: widget.user.celular,
                controller: _celularController,
                decoration: InputDecoration(
                  labelText: 'Celular',
                  labelStyle: TextStyle(color: mainColor),
                  // hintText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                    ),
                  ),
                ),
                autocorrect: false,
                validator: (String value) {
                  if (validator.isNull(value)) {
                    return '*Campo Requerido';
                  }

                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: _onButtonPressed,
                style: ElevatedButton.styleFrom(
                  primary: mainColor,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text('GUARDAR'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onButtonPressed() async {
    if (_key.currentState.validate()) {
      final blocPerfil = BlocProvider.of<PerfilBloc>(context);
      blocPerfil.add(SendPerfilEvent(
        user: widget.user.userId,
        token: widget.user.token,
        documento: _documentoController.text,
        celular: _celularController.text,
        imagen: image,
      ));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void get_data_form() async {
    String documento = await UserSecureStorage.getDocumento();
    String celular = await UserSecureStorage.getCelular();

    _documentoController.text = documento;
    _celularController.text = celular;
  }
}
