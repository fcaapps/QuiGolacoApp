import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quigolaco/pages/CadastroJogadores.dart';
import 'package:quigolaco/pages/LoginPage.dart';
import 'package:quigolaco/pages/drawer/AssistenciasPage.dart';
import 'package:quigolaco/pages/drawer/ConfigPage.dart';
import 'package:quigolaco/pages/drawer/Defesas.dart';
import 'package:quigolaco/pages/drawer/InicioPage.dart';
import 'package:quigolaco/pages/drawer/RankingPage.dart';
import 'package:quigolaco/widgets/DrawerPersonalizado.dart';

import 'drawer/GolsPage.dart';
import 'drawer/JogadoresPage.dart';

String ordenacao = "seq";
bool isDescending = false;

class HomePage extends StatefulWidget {

  final String usuarioL;
  final int indexPage;


  const HomePage({Key key, this.usuarioL, this.indexPage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  bool visivel = false;
  String usuario;

  Future _usuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado != null) {
      usuario = usuarioLogado.email;
    }
  }

  @override
  void initState() {
//    print(this.widget.indexPage);
    _usuarioLogado();
    super.initState();
  }

  GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();

  var pages = <Widget>[
    InicioPage(),
    JogadoresPage(),
    GolsPage(),
    AssistenciasPage(),
    Defesas(),
    RankingPage(),
    ConfigPage(),
  ];

  PageController _pageControl = PageController(initialPage: 0);

  bool ordemNome = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaffold,
      drawer: DrawerPersonalizado(
        usuario: this.widget.usuarioL,
        pageController: _pageControl,
        onPressed: (index) {
          _keyScaffold.currentState.openEndDrawer();
          _pageControl.jumpToPage(index);
          if (index == 1) {
            setState(() {
              visivel = true;
            });
          } else {
            setState(() {
              visivel = false;
            });
          }
          if (index == 7) {
            FirebaseAuth auth = FirebaseAuth.instance;
            auth.signOut();
            if (usuario != null) {
              //Navigator.of(context).pop();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }
          }
        },
      ),
      appBar: AppBar(
        actions: <Widget>[
          Visibility(
            visible: visivel,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) =>
                        CadastroJogadores()));
              },
              icon: Icon(Icons.add),
            ),
          ),
          SizedBox(width: 10,)
        ],
        elevation: 0,
//        automaticallyImplyLeading: false,
        backgroundColor: Color(0XFF4E7CA0),
        title: Row(
          children: <Widget>[
            Text(
              'Qui',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF7094AE)),
            ),
            Text(
              'Golaço!',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Color(0XFF365A7D),
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageControl,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _keyScaffold.currentState.openEndDrawer();
            if (index == 0) {
              _pageControl.jumpToPage(0);
            } else if (index == 1) {
              _pageControl.jumpToPage(5);
            } else {
              _pageControl.jumpToPage(2);
            }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Color(0XFF6F5A5B),
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0XFF6F5A5B),
                  ),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                  color: Color(0XFF6F5A5B),
                ),
                title: Text(
                  'Ranking',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0XFF6F5A5B),
                  ),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.blur_circular,
                  color: Color(0XFF6F5A5B),
                ),
                title: Text(
                  'Gols',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0XFF6F5A5B),
                  ),
                )),
          ]),
//      bottomNavigationBar: BottomAppBar(
//        color: Colors.white,
//        child: Container(
//            height: 60,
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                  child: GestureDetector(
//                    onTap: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) {
//                        return InicioPage();
//                      }));
//                    },
//                    child: Center(
//                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Icon(
//                            Icons.home,
//                            size: 30,
//                            color: Color(0XFF6F5A5B),
//                          ),
//                          Text(
//                            'Home',
//                            style: TextStyle(
//                                fontFamily: 'Raleway',
//                                color: Color(0XFF6F5A5B)),
//                          )
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//                Expanded(
//                  child: GestureDetector(
//                    onTap: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) {
//                        return RankingPage();
//                      }));
//                    },
//                    child: Center(
//                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Icon(
//                            Icons.list,
//                            size: 30,
//                            color: Color(0XFF6F5A5B),
//                          ),
//                          Text(
//                            'Ranking',
//                            style: TextStyle(
//                              fontFamily: 'Raleway',
//                              color: Color(0XFF6F5A5B),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//                Expanded(
//                  child: GestureDetector(
//                    onTap: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) {
//                        return GolsPage();
//                      }));
//                    },
//                    child: Center(
//                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Icon(
//                            Icons.blur_circular,
//                            size: 30,
//                            color: Color(0XFF6F5A5B),
//                          ),
//                          Text(
//                            'Gols',
//                            style: TextStyle(
//                              fontFamily: 'Raleway',
//                              color: Color(0XFF6F5A5B),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//                Expanded(
//                  child: GestureDetector(
//                    onTap: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) {
//                        return AssistenciasPage();
//                      }));
//                    },
//                    child: Center(
//                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Icon(
//                            Icons.brightness_auto,
//                            size: 30,
//                            color: Color(0XFF6F5A5B),
//                          ),
//                          Text(
//                            'Assistências',
//                            style: TextStyle(
//                              fontFamily: 'Raleway',
//                              color: Color(0XFF6F5A5B),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            )),
//      ),
      // body: Text(usuario),
    );
  }
}
