import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quigolaco/model/Jogadores.dart';
import 'package:quigolaco/pages/componentes/Component.dart';
import 'package:date_format/date_format.dart';

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

  String idDocumento;

  _cadastrarJogador(
      String nome,
      String especialidade,
      String descricao,
      String idade,
      String altura,
      String foto,
      String numGols,
      String numAssistencias,
      String numDefesas,
      String dtcadastro,
      int seq) async {
    //Coleção Jogadores
    db.collection("jogadores").document(nome).setData({
      "nome": nome,
      "especialidade": especialidade,
      "descricao": descricao,
      "idade": idade,
      "altura": altura,
      "foto": foto,
      "dtcadastro": dtcadastro,
      "seq": seq
    });

//    var ref = db
//        .collection("jogadores")
//        .where("nome", isEqualTo: nome)
//        .getDocuments();
//
//    ref.then((v) {
//      idDocumento = v.documents[0].documentID;
//      print(idDocumento);
//    });

    //Coleção Jogadores/Gols
    db
        .collection("jogadores")
        .document(nome)
        .collection("gols")
        .document()
        .setData({"data": DateTime.now(), "numGols": numGols});

    //Coleção Jogadores/Assistências
    db
        .collection("jogadores")
        .document(nome)
        .collection("assistencias")
        .document()
        .setData({"data": DateTime.now(), "numAssistencias": numAssistencias});

    //Coleção Jogadores/Defesas
    db
        .collection("jogadores")
        .document(nome)
        .collection("defesas")
        .document()
        .setData({"data": DateTime.now(), "numDefesas": numDefesas});
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
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Material(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKeyJogadores,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0XFF9F705B),
                              borderRadius: BorderRadius.circular(5)),
                          alignment: Alignment.center,
                          height: 200,
                          width: double.infinity,
                          child: CircleAvatar(
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
                              fontSize: 20,
                              color: Color(0XFF6F5A5B),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
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
                              fontSize: 20,
                              color: Color(0XFF6F5A5B),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
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
                              fontSize: 20,
                              color: Color(0XFF6F5A5B),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0XFF9F705B)),
                          keyboardType: TextInputType.text,
                          validator: (text) {
                            if (text.isEmpty)
                              return "Descrição é obrigatório!";
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
                              fontSize: 20,
                              color: Color(0XFF6F5A5B),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
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
                              fontSize: 20,
                              color: Color(0XFF6F5A5B),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0XFF9F705B)),
                          validator: (text) {
                            if (text.isEmpty) return "Altura é obrigatório!";
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: numGolsController,
                          decoration: InputDecoration(
                            hintText: 'Gols',
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: Color(0XFF6F5A5B),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0XFF9F705B)),
                          validator: (text) {
                            if (text.isEmpty) return "Gols é obrigatório!";
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: numAssistController,
                          decoration: InputDecoration(
                            hintText: 'Assistências',
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: Color(0XFF6F5A5B),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0XFF9F705B)),
                          validator: (text) {
                            if (text.isEmpty)
                              return "Assistências é obrigatório!";
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: numDefesasController,
                          decoration: InputDecoration(
                            hintText: 'Defesas',
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              color: Color(0XFF6F5A5B),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0XFF9F705B)),
                          validator: (text) {
                            if (text.isEmpty) return "Defesas é obrigatório!";
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
                            SizedBox(
                              width: 10,
                            ),
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
                              onPressed: () async {

                                QuerySnapshot querySnapshot = await db
                                    .collection("jogadores").orderBy("seq", descending: false)
                                    .getDocuments();

                                int count = 0;
                                querySnapshot.documents.forEach((d) {
                                  count++;
                                });

                                if (_formKeyJogadores.currentState
                                    .validate()) {
                                  if (_image != null) {
                                    if (_statusUpload == "") {
                                      _cadastrarJogador(
                                          nomeControlller.text,
                                          especialidadeControlller.text,
                                          descricaoControlller.text,
                                          idadeController.text,
                                          alturaController.text,
                                          _urlImagemRecuperada,
                                          numGolsController.text,
                                          numAssistController.text,
                                          numDefesasController.text,
                                          formatDate(DateTime.now(), [
                                            dd,
                                            '/',
                                            mm,
                                            '/',
                                            yyyy,
                                            ' ',
                                            HH,
                                            ':',
                                            nn
                                          ]),
                                          count + 1);

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
                                        content: Text(
                                            'Imagem ainda não carregada!'),
                                      );

                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: Center(
                                                  child: Text(
                                                    'Ok',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold,
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
        ));
  }
}
