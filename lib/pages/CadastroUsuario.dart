import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quigolaco/pages/componentes/Component.dart';

class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuários'),
        backgroundColor: Color(0XFF4E7CA0),
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                    ),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0XFF7094AE)),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text){
                      if(text.isEmpty || !text.contains("@")) return "E-mail inválido!";
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: senhaController,
                    decoration: InputDecoration(hintText: 'Senha'),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0XFF7094AE)),
                    validator: (text){
                      if(text.isEmpty || text.length < 6) return "Senha inválida!";
                    },
                  ),
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF4E7CA0),
        tooltip: 'Salvar Dados',
        child: const Icon(Icons.save),
        onPressed: () {
          if(_formKey.currentState.validate()){
            FirebaseAuth auth = FirebaseAuth.instance;

            auth.createUserWithEmailAndPassword(
              email: emailController.text,
              password: senhaController.text
            ).then((firebaseUser) {
              showDialog(
                context: context,
                builder: (context) {
                  return dialogLogin(
                      titulo: 'Aviso',
                      content: 'Usuário cadastro com sucesso!',
                      onPress: () {
                        Navigator.of(context).pop();
                        emailController.text = '';
                        senhaController.text = '';
                      });
                },
              );

            }).catchError((erro) {
              showDialog(
                context: context,
                builder: (context) {
                  return dialogLogin(
                      titulo: 'Aviso',
                      content: 'Novo usuário: erro' + erro.toString(),
                      onPress: () {
                        Navigator.of(context).pop();
                      });
                },
              );
            });

          }
        },
      ),
    );
  }
}
