import 'package:flutter/material.dart';
import 'package:quigolaco/pages/LoginPage.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0XFF4E7CA0),
    ),
    debugShowCheckedModeBanner: false,
    title: 'QuiGolaço',
    home: LoginPage(),
  ));
}
