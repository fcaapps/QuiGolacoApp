import 'package:flutter/material.dart';
import 'package:quigolaco/pages/HomePage.dart';

class InicioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        height: 180,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: Color(0XFF6F5A5B), blurRadius: 4)
                            ]),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            FlatButton(
                              child: Icon(
                                Icons.list,
                                size: 100,
                                color: Colors.black54,
                              ),
//                              onPressed: () {
//                                print('Rankig');
//                                Navigator.push(context, MaterialPageRoute(builder: (context) {
//                                  return HomePage(indexPage: 2);
//                                }));
//                              },
                            ),
                            Text(
                              'Ranking',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            Container(
                              child: Text('Gols, Assistências e Defesas',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black26),
                                  textAlign: TextAlign.center),
                            )
                          ],
                        ))),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 5),
                        padding: EdgeInsets.all(12),
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: Color(0XFF6F5A5B), blurRadius: 4)
                            ]),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.blur_circular,
                              size: 30,
                              color: Colors.black54,
                            ),
                            Text(
                              'Gols',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            Container(
                              child: Text('Aponte seus gols',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black26),
                                  textAlign: TextAlign.center),
                            )
                          ],
                        ))),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 10, left: 5),
                        padding: EdgeInsets.all(12),
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: Color(0XFF6F5A5B), blurRadius: 4)
                            ]),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.brightness_auto,
                              size: 30,
                              color: Colors.black54,
                            ),
                            Text(
                              'Assistências',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            Container(
                              child: Text('Aponte suas assistências',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black26),
                                  textAlign: TextAlign.center),
                            )
                          ],
                        ))),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: Color(0XFF6F5A5B), blurRadius: 4)
                            ]),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.accessibility_new,
                              size: 30,
                              color: Colors.black54,
                            ),
                            Text(
                              'Defesas',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            Container(
                              child: Text('Aponte suas defesas',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black26),
                                  textAlign: TextAlign.center),
                            )
                          ],
                        ))),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                      height: 90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Color(0XFF6F5A5B), blurRadius: 4)
                          ]),
                        child: Center(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.contact_mail,
                                  size: 30,
                                  color: Colors.black54,
                                ),
                                Text(
                                  'Melhor da Semana',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                                Container(
                                  child: Text('Acompanhe o melhor da semana por modalidade',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black26),
                                      textAlign: TextAlign.center),
                                )
                              ],
                            ))
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
