import 'package:flutter/material.dart';
import 'package:quigolaco/model/Usuario.dart';
import 'package:quigolaco/pages/CadastroUsuario.dart';
import 'package:quigolaco/pages/HomePage.dart';
import 'package:quigolaco/pages/ResetPasswordPage.dart';

import 'componentes/Component.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

  final String warning;
  final bool isVisible;

  const LoginPage({Key key, this.warning, this.isVisible}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Component {
  bool isLoading = false;

  String usuario;

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _mensagemErro = "";

  String _warning;
  bool _isVisible;

  _validarCampos() {
    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        usuario.setEmail = email;
        usuario.setSenha = senha;

        _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha!";
          showDialog(
            context: context,
            builder: (context) {
              return dialogLogin(
                  titulo: 'Aviso',
                  content: _mensagemErro,
                  onPress: () {
                    setState(() {
                      isLoading = !isLoading;
                    });
                    Navigator.of(context).pop();
                  });
            },
          );
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o E-mail utilizando @";
        showDialog(
          context: context,
          builder: (context) {
            return dialogLogin(
                titulo: 'Aviso',
                content: _mensagemErro,
                onPress: () {
                  setState(() {
                    isLoading = !isLoading;
                  });
                  Navigator.of(context).pop();
                });
          },
        );
      });
    }
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage(usuarioL: firebaseUser.email);
      }));
    }).catchError((error) {
      setState(() {
        _mensagemErro =
            "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";

        showDialog(
          context: context,
          builder: (context) {
            return dialogLogin(
                titulo: 'Aviso',
                content: _mensagemErro,
                onPress: () {
                  setState(() {
                    isLoading = !isLoading;
                  });
                  Navigator.of(context).pop();
                });
          },
        );
      });
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();

    FirebaseUser usuarioLogado = await auth.currentUser();

    if (usuarioLogado != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    usuarioL: usuarioLogado.email,
                  )));
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    _warning = this.widget.warning;
    _isVisible = this.widget.isVisible;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                headerLogin(),
                logoLogin(),
                Padding(
                    padding: EdgeInsets.only(top: 300, left: 30, right: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(top: 1),
                              child: txtfieldLogin(
                                  altura: 55,
                                  backColor: Colors.white,
                                  blurR: 10,
                                  borderR: 10,
                                  borderShadowColor: Color(0XFF7094AE),
                                  fSize: 20,
                                  icon: Icons.email,
                                  iconColor: Color(0XFF7094AE),
                                  obscText: false,
                                  hText: 'E-mail',
                                  sizeIcon: 30,
                                  controll: _controllerEmail,
                                  textInputType: TextInputType.emailAddress)),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: txtfieldLogin(
                                altura: 55,
                                backColor: Colors.white,
                                blurR: 10,
                                borderR: 10,
                                borderShadowColor: Color(0XFF7094AE),
                                fSize: 20,
                                icon: Icons.no_encryption,
                                iconColor: Color(0XFF7094AE),
                                obscText: true,
                                hText: 'Senha',
                                sizeIcon: 30,
                                controll: _controllerSenha),
                          ),
                          Container(
                            height: 30,
                            alignment: Alignment.topRight,
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResetPasswordPage()));
                              },
                              child: Text(
                                "Recuperar Senha",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                    color: Color(0XFF7094AE)),
                              ),
                            ),
                          ),
                          btnEntrar(
                              titulo: 'ENTRAR',
                              isLoading: isLoading,
                              widthButao:
                                  MediaQuery.of(context).size.width - 60,
                              validarCampos: () {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                                _validarCampos();
                              }),
                          btnCadastrese(
                              titulo: 'CADASTRE-SE',
                              cadastreUsuario: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CadastroUsuario()));
                              }),
                          btnPular(titulo: 'PULAR')
//                          Align(
//                            alignment: Alignment.center,
//                            child: FlatButton(
//                              padding: EdgeInsets.zero,
//                              onPressed: () {},
//                              child: Text(
//                                "PULAR",
//                                textAlign: TextAlign.right,
//                                style: TextStyle(
//                                    fontSize: 14,
//                                    fontFamily: 'Raleway',
//                                    fontWeight: FontWeight.bold,
//                                    color: Color(0XFF6F5A5B)),
//                              ),
//                            ),
//                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Visibility(
                    child: showAlert(),
                    visible: _isVisible == true ? true : false,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 1],
                colors: [Color(0XFFCAA772), Color(0XFF9F705B)])),
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                _warning,
                maxLines: 3,
                style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                    _isVisible = false;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
