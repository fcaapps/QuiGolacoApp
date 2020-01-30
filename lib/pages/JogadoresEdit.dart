import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quigolaco/model/Jogadores.dart';
import 'package:intl/intl.dart';
import 'package:quigolaco/pages/JogadoresDetalhes.dart';

void main() {
  runApp(MaterialApp(
    title: 'Editar Jogadores',
    home: JogadoresEdit(),
  ));
}

class JogadoresEdit extends StatefulWidget {
  final String nomeJogador;
  final String caminhoFoto;
  final String especialidade;
  final String descricaoJogador;
  final String idadeJogador;
  final String alturaJogador;

  const JogadoresEdit(
      {Key key,
      this.nomeJogador,
      this.caminhoFoto,
      this.especialidade,
      this.descricaoJogador,
      this.idadeJogador,
      this.alturaJogador})
      : super(key: key);

  @override
  _JogadoresEditState createState() => _JogadoresEditState();
}

class _JogadoresEditState extends State<JogadoresEdit> {
  File _image;
  File imagemSelecionada;
  String _statusUpload = "";
  String _urlImagemRecuperada;

  final TextEditingController nomeControlller = TextEditingController();
  final TextEditingController especialidadeControlller =
      TextEditingController();
  final TextEditingController descricaoControlller = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController numGolsController = TextEditingController();
  final TextEditingController numAssistController = TextEditingController();
  final TextEditingController numDefesasController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  List<DropdownMenuItem<String>> listaEspecialidade = [];
  String selected = null;

  void loadEspecialidade() {
    listaEspecialidade = [];
    listaEspecialidade.add(new DropdownMenuItem(
      child: SizedBox(
        width: 115,
        child: Text(
          'Atacante',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey),
        ),
      ),
      value: "Atacante",
    ));
    listaEspecialidade.add(new DropdownMenuItem(
      child: SizedBox(
        width: 120,
        child: Text(
          'Meio de Quadra',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey),
        ),
      ),
      value: "Meio de Quadra",
    ));
    listaEspecialidade.add(new DropdownMenuItem(
      child: SizedBox(
        width: 115,
        child: Text(
          'Zagueiro',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey),
        ),
      ),
      value: "Zagueiro",
    ));
    listaEspecialidade.add(new DropdownMenuItem(
      child: SizedBox(
        width: 115,
        child: Text(
          'Goleiro',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey),
        ),
      ),
      value: "Goleiro",
    ));
    listaEspecialidade.add(new DropdownMenuItem(
      child: SizedBox(
        width: 115,
        child: Text(
          'Ala',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey),
        ),
      ),
      value: "Ala",
    ));
  }

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

    String nomefoto =
        (DateFormat('yyyyMMddHms').format(DateTime.now())).toString() + ".jpg";

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

  idDoc(String nome) {
    Firestore db = Firestore.instance;

    var ref = db
        .collection("jogadores")
        .where("nome", isEqualTo: nome)
        .getDocuments();

    ref.then((v) {
      idDocumento = v.documents[0].documentID;
      print(idDocumento);
    });
  }

  @override
  Widget build(BuildContext context) {
    loadEspecialidade();
    nomeControlller.text = this.widget.nomeJogador;
    especialidadeControlller.text = this.widget.especialidade;
    descricaoControlller.text = this.widget.descricaoJogador;
    idadeController.text = this.widget.idadeJogador;
    alturaController.text = this.widget.alturaJogador;
    idDoc(this.widget.nomeJogador);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Editando ' + this.widget.nomeJogador,
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: Colors.blue, blurRadius: 0)
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 60),
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      //border: Border.all(color: Colors.blueAccent, width: 2),
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: Colors.black54, blurRadius: 8)
                      ]),
                  child: Center(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: _urlImagemRecuperada != null
                            ? _urlImagemRecuperada
                            : this.widget.caminhoFoto,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
//                    child: CircleAvatar(
//                      child: Text(
//                        _statusUpload,
//                        style: TextStyle(
//                            fontFamily: 'Roboto',
//                            fontWeight: FontWeight.bold,
//                            fontSize: 15,
//                            color: Colors.white),
//                      ),
//                      radius: 56,
//                      backgroundColor: Colors.grey,
//                      backgroundImage: _urlImagemRecuperada != null
//                          ? NetworkImage(_urlImagemRecuperada)
//                          : NetworkImage(this.widget.caminhoFoto),
//                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 120, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _recuperarImagem(true);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.image,
                      size: 30,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _recuperarImagem(false);
                    },
                  )
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 177, left: 30, right: 30),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: nomeControlller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color(0XFF4A3949)),
                      keyboardType: TextInputType.text,
                      validator: (text) {
                        if (text.isEmpty) return "Nome é obrigatório!";
                      },
                    ),
//                    Text(
//                      this.widget.nomeJogador,
//                      style: TextStyle(
//                          fontFamily: 'Roboto',
//                          fontWeight: FontWeight.bold,
//                          fontSize: 30,
//                          color: Color(0XFF4A3949)),
//                    ),
                    Text(
                      'Especialidade:',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0XFFCAA772)),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selected == null
                            ? this.widget.especialidade
                            : selected,
                        items: listaEspecialidade,
                        onChanged: (value) {
                          setState(() {
                            selected = value;
                          });
                        },
                      ),
                    ),
//                    Container(
//                      width: 150,
//                      child: TextFormField(
//                        decoration: InputDecoration(
//                          suffix: DropdownButtonHideUnderline(
//                            child: DropdownButton(
//                              //value: selected,
//                              items: listaEspecialidade,
//                              onChanged: (value) {
//                                especialidadeControlller.text = value;
//                                setState(() {});
//                              },
//                            ),
//                          ),
//                        ),
//                        textAlign: TextAlign.right,
//                        controller: especialidadeControlller,
//                        style: TextStyle(
//                            fontFamily: 'Roboto',
//                            fontWeight: FontWeight.bold,
//                            fontSize: 16,
//                            color: Colors.grey),
//                        keyboardType: TextInputType.text,
//                        validator: (text) {
//                          if (text.isEmpty) return "Especialidade é obrigatório!";
//                        },
//                      ),
//                    ),
//                    Text(
//                      this.widget.especialidade,
//                      style: TextStyle(
//                          fontFamily: 'Raleway',
//                          fontWeight: FontWeight.bold,
//                          fontSize: 16,
//                          color: Colors.grey),
//                    ),
                    Divider(),
                    Text(
                      'Descrição:',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0XFFCAA772)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Colors.grey, blurRadius: 2)
                          ]),
                      child: TextFormField(
                        controller: descricaoControlller,
                        maxLines: 4,
                        decoration: InputDecoration(border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey),
                        keyboardType: TextInputType.text,
                        validator: (text) {
                          if (text.isEmpty) return "Descrição é obrigatório!";
                        },
                      ),
//                      child: Text(
//                        this.widget.descricaoJogador ?? '',
//                        textAlign: TextAlign.center,
//                        style: TextStyle(
//                            fontFamily: 'Raleway',
//                            fontWeight: FontWeight.bold,
//                            fontSize: 16,
//                            color: Colors.grey),
//                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Idade:',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0XFFCAA772)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 25,
                              width: 40,
                              child: TextFormField(
                                controller: idadeController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey),
                                validator: (text) {
                                  if (text.isEmpty)
                                    return "Idade é obrigatório!";
                                },
                              ),
                            ),

//                            Text(
//                              this.widget.idadeJogador + ' anos',
//                              style: TextStyle(
//                                  fontFamily: 'Raleway',
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 16,
//                                  color: Colors.grey),
//                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Altura:',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0XFFCAA772)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 25,
                              width: 40,
                              child: TextFormField(
                                controller: alturaController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey),
                                validator: (text) {
                                  if (text.isEmpty)
                                    return "Altura é obrigatório!";
                                },
                              ),
                            ),
//                            Text(
//                              this.widget.alturaJogador ?? '',
//                              style: TextStyle(
//                                  fontFamily: 'Raleway',
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 16,
//                                  color: Colors.grey),
//                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        tooltip: 'Salvar Dados',
        child: const Icon(Icons.save),
        onPressed: () {
          Firestore db = Firestore.instance;
          db.collection("jogadores").document(idDocumento).setData({
            "nome": nomeControlller.text,
            "especialidade":
                selected == null ? this.widget.especialidade : selected,
            "descricao": descricaoControlller.text,
            "idade": idadeController.text,
            "altura": alturaController.text,
            "foto": _urlImagemRecuperada == null
                ? this.widget.caminhoFoto
                : _urlImagemRecuperada
          });

          Navigator.of(context).pop();
          Navigator.of(context).pop();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => JogadoresDetalhes(
                        caminhoFoto: _urlImagemRecuperada == null
                            ? this.widget.caminhoFoto
                            : _urlImagemRecuperada,
                        nomeJogador: nomeControlller.text,
                        especialidade: selected == null
                            ? especialidadeControlller.text
                            : selected,
                        descricaoJogador: descricaoControlller.text,
                        idadeJogador: idadeController.text,
                        alturaJogador: alturaController.text,
                      )));
        },
      ),
    );
  }
}
