import 'package:flutter/material.dart';

class Component {
// Cabeçalho
  Widget headerLogin() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: Color(0XFF4E7CA0),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100)),
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.blue, blurRadius: 0)]),
    );
  }

//Logo
  Widget logoLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 130),
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              //border: Border.all(color: Colors.blueAccent, width: 2),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black54, blurRadius: 8)
              ]),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Qui',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF7094AE),
                    fontFamily: 'Roboto'),
              ),
              Text(
                'Golaço!',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF365A7D),
                    fontFamily: 'Roboto'),
              )
            ],
          )),
        ),
      ],
    );
  }

//TextField Email e Senha
  Widget txtfieldLogin(
      {double altura,
      Color backColor,
      double borderR,
      double blurR,
      Color borderShadowColor,
      TextEditingController controll,
      bool obscText,
      String hText,
      double fSize,
      IconData icon,
      Color iconColor,
      double sizeIcon,
      TextInputType textInputType}) {
    return Container(
      height: altura,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(borderR),
          border: Border.all(color: borderShadowColor),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: borderShadowColor,
              blurRadius: blurR,
            )
          ]),
      child: TextFormField(
        controller: controll,
        obscureText: obscText,
        style: TextStyle(
            fontSize: fSize,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Color(0XFF7094AE)),
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Color(0XFF7094AE)),
            contentPadding: EdgeInsets.only(bottom: 12),
            hintText: hText,
            labelStyle: TextStyle(
              backgroundColor: backColor,
            ),
            icon: Icon(
              icon,
              color: iconColor,
              size: sizeIcon,
            ),
            border: InputBorder.none),
        keyboardType: textInputType,
//        validator: validador,
      ),
    );
  }

//Butão Entrar
  Widget btnEntrar(
      {String titulo,
      bool isLoading,
      double widthButao,
      Function validarCampos}) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isLoading ? 50 : 10),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Color(0XFF47769B), blurRadius: 1)
            ],
            color: Color(0XFF47769B)),
        height: 45,
        width: isLoading ? 45 : widthButao,
        alignment: Alignment.center,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                titulo,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
      ),
      onTap: () {
        validarCampos();
      },
    );
  }

//Butão Cadastre-se
  Widget btnCadastrese({String titulo, Function cadastreUsuario}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Color(0XFF47769B), width: 3),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Color(0XFF47769B), blurRadius: 1)
            ]),
        height: 45,
        alignment: Alignment.center,
        child: Text(
          titulo,
          style: TextStyle(
            fontSize: 14,
            color: Color(0XFF47769B),
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      onTap: () {
        cadastreUsuario();
      },
    );
  }

// Butão Pular
  Widget btnPular({String titulo}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0XFF6F5A5B),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Color(0XFF6F5A5B), blurRadius: 1)
          ],
        ),
        height: 45,
        alignment: Alignment.center,
        child: Text(
          titulo,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  Widget DrawerPersonalizado({Color cor, FontWeight fontW, Function(int) onPressed, String usuario}) {
    return Drawer(
        child: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Color(0XFF7094AE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  height: 80,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Qui',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Color(0XFF7094AE)),
                          ),
                          Text(
                            'Golaço!',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Color(0XFF365A7D)),
                          )
                        ],
                      ),
                      Text(
                        'Bem-vindo, $usuario...',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF6F5A5B)),
                      )
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: cor
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 17,
                        color: cor,
                        fontWeight: fontW),
                  ),
                  onTap: () {
                    onPressed(0);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.people,
                    color: cor,
                  ),
                  title: Text(
                    'Jogadores',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 17,
                        color: cor,
                        fontWeight: fontW),
                  ),
                  onTap: () {
                    onPressed(1);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.list,
                    color: cor,
                  ),
                  title: Text(
                    'Ranking',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 17,
                        color: cor,
                        fontWeight: fontW),
                  ),
                  onTap: () {
                    onPressed(4);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.blur_circular,
                    color: cor,
                  ),
                  title: Text(
                    'Gols',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 17,
                        color: cor,
                        fontWeight: fontW),
                  ),
                  onTap: () {
                    onPressed(2);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.brightness_auto,
                    color: cor,
                  ),
                  title: Text(
                    'Assistências',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 17,
                        color: cor,
                        fontWeight: fontW),
                  ),
                  onTap: () {
                    onPressed(3);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.build,
                    color: cor,
                  ),
                  title: Text(
                    'Configurações',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 17,
                        color: cor,
                        fontWeight: fontW),
                  ),
                  onTap: () {
                    onPressed(5);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.close,
                    color: Colors.black54,
                  ),
                  title: Text(
                    'Sair',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 17,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

//Dialog
Widget dialogLogin({String titulo, String content, Function onPress}) {
  return AlertDialog(
    elevation: 10,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    title: Text(
      titulo,
      style: TextStyle(
          fontSize: 30,
          fontFamily: 'Roboto',
          color: Color(0XFF365A7D),
          fontWeight: FontWeight.bold),
    ),
    content: Text(
      content,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Raleway',
        color: Color(0XFF7094AE),
      ),
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          onPress();
        },
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: Color(0XFF365A7D),
              borderRadius: BorderRadius.circular(100)),
          child: Center(
            child: Text(
              'Ok',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      )
    ],
  );
}
