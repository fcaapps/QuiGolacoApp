import 'package:flutter/material.dart';

class DrawerPersonalizado extends StatelessWidget {
  final String usuario;
  final Function(int) onPressed;
  final PageController pageController;

  const DrawerPersonalizado({Key key, this.onPressed, this.pageController, this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        color: pageController.page == 0 ? Color(0XFF365A7D) : Colors.black54,
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17,
                            color: pageController.page == 0 ? Color(0XFF365A7D) : Colors.black54,
                            fontWeight: pageController.page == 0 ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onTap: () {
                        onPressed(0);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.people,
                        color: pageController.page == 1 ? Color(0XFF365A7D) : Colors.black54,
                      ),
                      title: Text(
                        'Jogadores',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17,
                            color: pageController.page == 1 ? Color(0XFF365A7D) : Colors.black54,
                            fontWeight: pageController.page == 1 ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onTap: () {
                        onPressed(1);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.blur_circular,
                        color: pageController.page == 2 ? Color(0XFF365A7D) : Colors.black54,
                      ),
                      title: Text(
                        'Gols',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17,
                            color: pageController.page == 2 ? Color(0XFF365A7D) : Colors.black54,
                            fontWeight: pageController.page == 2 ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onTap: () {
                        onPressed(2);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.brightness_auto,
                        color: pageController.page == 3 ? Color(0XFF365A7D) : Colors.black54,
                      ),
                      title: Text(
                        'Assistências',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17,
                            color: pageController.page == 3 ? Color(0XFF365A7D) : Colors.black54,
                            fontWeight: pageController.page == 3 ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onTap: () {
                        onPressed(3);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.accessibility_new,
                        color: pageController.page == 4 ? Color(0XFF365A7D) : Colors.black54,
                      ),
                      title: Text(
                        'Defesas',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17,
                            color: pageController.page == 4 ? Color(0XFF365A7D) : Colors.black54,
                            fontWeight: pageController.page == 4 ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onTap: () {
                        onPressed(4);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.list,
                        color: pageController.page == 5 ? Color(0XFF365A7D) : Colors.black54,
                      ),
                      title: Text(
                        'Ranking',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17,
                            color: pageController.page == 5 ? Color(0XFF365A7D) : Colors.black54,
                            fontWeight: pageController.page == 5 ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onTap: () {
                        onPressed(5);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.build,
                        color: pageController.page == 6 ? Color(0XFF365A7D) : Colors.black54,
                      ),
                      title: Text(
                        'Configurações',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17,
                            color: pageController.page == 6 ? Color(0XFF365A7D) : Colors.black54,
                            fontWeight: pageController.page == 6 ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onTap: () {
                        onPressed(6);
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
