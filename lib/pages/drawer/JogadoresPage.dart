import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quigolaco/model/Jogadores.dart';
import 'package:intl/intl.dart';
import 'package:quigolaco/pages/JogadoresDetalhes.dart';

class JogadoresPage extends StatefulWidget {
  @override
  _JogadoresPageState createState() => _JogadoresPageState();
}

class _JogadoresPageState extends State<JogadoresPage> {
  bool _subindoImagem = false;
  String _urlImagemRecuperada;

  Firestore db = Firestore.instance;

  String _urlFotoRecuperada;

  final TextEditingController nomeControlller = TextEditingController();
  final TextEditingController especialidadeControlller =
      TextEditingController();
  final TextEditingController descricaoControlller = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController numGolsController = TextEditingController();
  final TextEditingController numAssistController = TextEditingController();
  final TextEditingController numDefesasController = TextEditingController();

  final _formKeyJogadores = GlobalKey<FormState>();

  File _image;
  File imagemSelecionada;
  String _statusUpload = "";

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

  @override
  void initState() {
    listarJogadores();
    super.initState();
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
    return Material(
      child: DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Container(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              bottom: PreferredSize(
                child: TabBar(
                  labelColor: Color(0XFF4E7CA0),
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      color: Colors.white),
                  tabs: <Widget>[
                    Tab(
                        child: Center(
                      child: Text(
                        'CADASTRO',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    Tab(
                        child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'LISTA',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Color(0XFF7094AE), blurRadius: 3)
                        ]),
                    child: Center(
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Form(
                            key: _formKeyJogadores,
                            child: Column(
                              children: <Widget>[
//                                Container(
//                                  margin: EdgeInsets.all(10),
//                                  alignment: Alignment.center,
//                                  height: 20,
//                                  child: Text(
//                                    _statusUpload,
//                                    style: TextStyle(
//                                        fontFamily: 'Roboto',
//                                        fontWeight: FontWeight.bold,
//                                        color: Color(0XFF9F705B)),
//                                  ),
//                                ),
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
                                    if (text.isEmpty)
                                      return "Nome é obrigatório!";
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
//                                Row(
//                                  mainAxisSize: MainAxisSize.min, // see 3
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Flexible( // see 3
//                                      child: DropdownButtonHideUnderline(
//                                        child: DropdownButton(
//                                          //value: selected,
//                                          items: listaEspecialidade,
//                                          onChanged: (value) {
//                                            especialidadeControlller.text =
//                                                value;
//                                            setState(() {
//
//                                            });
//                                          },
//                                        ),
//                                      ),
//                                    ),
//                                    Flexible(
//                                      child: TextFormField(
//                                        controller: especialidadeControlller,
//                                        decoration: InputDecoration(
//                                          hintText: 'Especialidade',
//                                          hintStyle: TextStyle(
//                                            fontFamily: 'Roboto',
//                                            fontSize: 15,
//                                            color: Color(0XFF6F5A5B),
//                                          ),
//                                        ),
//                                        style: TextStyle(
//                                            fontFamily: 'Roboto',
//                                            fontWeight: FontWeight.bold,
//                                            fontSize: 15,
//                                            color: Color(0XFF9F705B)),
//                                        keyboardType: TextInputType.text,
//                                        validator: (text) {
//                                          if (text.isEmpty)
//                                            return "Especialidade é obrigatório!";
//                                        },
//                                      ),
//                                    ),
//                                  ],
//                                ),
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
                                  maxLines: 4,
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
                                    if (text.isEmpty)
                                      return "Idade é obrigatório!";
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
                                    if (text.isEmpty)
                                      return "Altura é obrigatório!";
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                RaisedButton(
                                  color: Color(0XFF9F705B),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: Text(
                                      'Gravar Dados',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
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
                                              _urlImagemRecuperada);

                                          nomeControlller.text = '';
                                          especialidadeControlller.text = '';
                                          descricaoControlller.text = '';
                                          idadeController.text = '';
                                          alturaController.text = '';
                                          _image = null;
                                          _urlImagemRecuperada = null;

                                          setState(() {
                                            listarJogadores();
                                          });

                                          final snackBar = SnackBar(
                                            content: Text(
                                                'Dados gravado com sucesso!'),
                                            action: SnackBarAction(
                                              label: 'Desfazer',
                                              onPressed: () {
                                                // Some code to undo the change.
                                              },
                                            ),
                                          );

                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                'Imagem ainda não carregada!'),
                                          );

                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      } else {
                                        final snackBar = SnackBar(
                                          content: Text('Carregar imagem...'),
                                        );

                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                  },
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
                FutureBuilder<List<Jogadores>>(
                    future: listarJogadores(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                          break;
                        case ConnectionState.active:
                        case ConnectionState.done:
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, indice) {
                              List<Jogadores> listaItens = snapshot.data;
                              Jogadores jogadores = listaItens[indice];

                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Card(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return JogadoresDetalhes(
                                          nomeJogador: jogadores.nome,
                                          caminhoFoto:
                                              jogadores.caminhoFoto != null
                                                  ? jogadores.caminhoFoto
                                                  : null,
                                          especialidade:
                                              jogadores.especialidade,
                                          descricaoJogador: jogadores.descricao,
                                          idadeJogador: jogadores.idade,
                                          alturaJogador: jogadores.altura,
                                        );
                                      }));
                                    },
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    leading: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            jogadores.caminhoFoto != null
                                                ? NetworkImage(
                                                    jogadores.caminhoFoto)
                                                : null),
                                    title: Text(
                                      jogadores.nome,
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0XFF6F5A5B)),
                                    ),
                                    subtitle: Text(
                                      jogadores.especialidade +
                                          " | " +
                                          jogadores.idade +
                                          " anos | " +
                                          jogadores.altura +
                                          " de altura",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      maxLines: 4,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          break;
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
