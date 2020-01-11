import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quigolaco/pages/LoginPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: RaisedButton(
        onPressed: () {
          FirebaseAuth auth = FirebaseAuth.instance;
          auth.signOut();
          MaterialPageRoute(
              builder: (context) => LoginPage()
          );
        },
        child: Text('Sair'),
      ),
    ));
  }
}
