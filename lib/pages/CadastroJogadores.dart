import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quigolaco/model/Jogadores.dart';
import 'package:quigolaco/pages/componentes/Component.dart';

void main() {
  runApp(MaterialApp(
    title: 'Home',
    home: CadastroJogadores(),
  ));
}

class CadastroJogadores extends StatefulWidget {
  @override
  _CadastroJogadoresState createState() => _CadastroJogadoresState();
}

class _CadastroJogadoresState extends State<CadastroJogadores> with Component {
  final _formKeyJogadores = GlobalKey<FormState>();
  String _statusUpload = "";
  String _urlImagemRecuperada;
  File _image;
  File imagemSelecionada;
  Firestore db = Firestore.instance;

  final TextEditingController nomeControlller = TextEditingController();
  final TextEditingController especialidadeControlller =
      TextEditingController();
  final TextEditingController descricaoControlller = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController numGolsController = TextEditingController();
  final TextEditingController numAssistController = TextEditingController();
  final TextEditingController numDefesasController = TextEditingController();

  Future _recuperarImagem(bool daCamera) async {
    if (daCamera) {
      imagemSelecionada =
          await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      imagemSelecionada =
          await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = imagemSelecionada;
    });

    _uploadImagem();
  }

  Future _uploadImagem() async {
//    String nomefoto = nomeControlller.text.toUpperCase().substring(0, 3) +
//        idadeController.text +
//        ".jpg";

    String nomefoto = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    //print((await pastaRaiz.getDownloadURL()).toString());
    StorageReference arquivo =
        pastaRaiz.child("fotos").child("jogadores").child(nomefoto);

    //Fazer Upload da Imagem
    StorageUploadTask task = arquivo.putFile(_image);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _statusUpload = "Carregando...";
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _statusUpload = "";
        });
      }
    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    //_atualizarUrlImagemFirestore( url );

    setState(() {
      _urlImagemRecuperada = url;
    });

    print(_urlImagemRecuperada);
  }

  _cadastrarJogador(String nome, String especialidade, String descricao,
      String idade, String altura, String foto) {
    db.collection("jogadores").add({
      "nome": nome,
      "especialidade": especialidade,
      "descricao": descricao,
      "idade": idade,
      "altura": altura,
      "foto": foto
    });
  }

  Future<List<Jogadores>> listarJogadores() async {
    QuerySnapshot querySnapshot =
        await db.collection("jogadores").getDocuments();

    List<Jogadores> listaJogadores = List();

    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;

      Jogadores jogadores = Jogadores();

      jogadores.nome = dados["nome"];
      jogadores.especialidade = dados["especialidade"];
      jogadores.descricao = dados["descricao"];
      jogadores.idade = dados["idade"];
      jogadores.altura = dados["altura"];
      jogadores.caminhoFoto = dados["foto"];

      listaJogadores.add(jogadores);
    }
    return listaJogadores;
  }

  List<DropdownMenuItem<String>> listaEspecialidade = [];
  String selected = null;

  void loadEspecialidade() {
    listaEspecialidade = [];
    listaEspecialidade.add(new DropdownMenuItem(
      child: new Text('Atacante'),
      value: "Atacante",
    ));
    listaEspecialidade.add(new DropdownMenuItem(
      child: new Text('Meio de Quadra'),
      value: "Meio de Quadra",
    ));
    listaEspecialidade.add(new DropdownMenuItem(
      child: new Text('Zagueiro'),
      value: "Zagueiro",
    ));
    listaEspecialidade.add(new DropdownMenuItem(
      child: new Text('Goleiro'),
      value: "Goleiro",
    ));
    listaEspecialidade.add(new DropdownMenuItem(
      child: new Text('Ala'),
      value: "Ala",
    ));
  }

  @override
  Widget build(BuildContext context) {
    loadEspecialidade();
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.black54, blurRadius: 2)
            ]),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Material(
          child: Container(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: _formKeyJogadores,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          CircleAvatar(
                            child: Text(
                              _statusUpload,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            radius: 80,
                            backgroundColor: Colors.grey,
                            backgroundImage: _urlImagemRecuperada != null
                                ? NetworkImage(_urlImagemRecuperada)
                                : null,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  _recuperarImagem(true);
                                },
                                child: Text(
                                  'Câmera',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0XFF9F705B),
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  _recuperarImagem(false);
                                },
                                child: Text('Galeria',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0XFF9F705B),
                                    )),
                              )
                            ],
                          ),
                          TextFormField(
                            controller: nomeControlller,
                            decoration: InputDecoration(
                              hintText: 'Nome',
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: Color(0XFF6F5A5B),
                              ),
                            ),
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0XFF9F705B)),
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text.isEmpty) return "Nome é obrigatório!";
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: especialidadeControlller,
                            decoration: InputDecoration(
                              suffix: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  //value: selected,
                                  items: listaEspecialidade,
                                  onChanged: (value) {
                                    especialidadeControlller.text = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                              hintText: 'Especialidade',
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: Color(0XFF6F5A5B),
                              ),
                            ),
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0XFF9F705B)),
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text.isEmpty)
                                return "Especialidade é obrigatório!";
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: descricaoControlller,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Descrição',
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: Color(0XFF6F5A5B),
                              ),
                            ),
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0XFF9F705B)),
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text.isEmpty) return "Descrição é obrigatório!";
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: idadeController,
                            decoration: InputDecoration(
                              hintText: 'Idade',
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: Color(0XFF6F5A5B),
                              ),
                            ),
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0XFF9F705B)),
                            validator: (text) {
                              if (text.isEmpty) return "Idade é obrigatório!";
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: alturaController,
                            decoration: InputDecoration(
                              hintText: 'Altura',
                              hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: Color(0XFF6F5A5B),
                              ),
                            ),
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0XFF9F705B)),
                            validator: (text) {
                              if (text.isEmpty) return "Altura é obrigatório!";
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              RaisedButton(
                                color: Color(0XFF9F705B),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: Text(
                                    'Fechar',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(width: 10,),
                              RaisedButton(
                                color: Color(0XFF9F705B),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: Text(
                                    'Gravar',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKeyJogadores.currentState.validate()) {
                                    if (_image != null) {
                                      if (_statusUpload == "") {
                                        _cadastrarJogador(
                                            nomeControlller.text,
                                            especialidadeControlller.text,
                                            descricaoControlller.text,
                                            idadeController.text,
                                            alturaController.text,
                                            _urlImagemRecuperada);

                                        nomeControlller.text = '';
                                        especialidadeControlller.text = '';
                                        descricaoControlller.text = '';
                                        idadeController.text = '';
                                        alturaController.text = '';
                                        _image = null;
                                        _urlImagemRecuperada = null;

                                        Navigator.pop(context);

                                      } else {
                                        final snackBar = SnackBar(
                                          content:
                                          Text('Imagem ainda não carregada!'),
                                        );

                                        Scaffold.of(context).showSnackBar(snackBar);
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                            title: Text(
                                              'Aviso',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Roboto',
                                                  color: Color(0XFF9F705B),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              'Favor carregar imagem...',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Raleway',
                                                color: Color(0XFF9F705B),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Color(0XFF9F705B),
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
                                        },
                                      );
                                    }
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ));
  }
}
