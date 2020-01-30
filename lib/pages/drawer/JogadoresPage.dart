import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quigolaco/model/Jogadores.dart';
import 'package:intl/intl.dart';
import 'package:quigolaco/pages/JogadoresDetalhes.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      child: StreamBuilder(
        stream: db.collection("jogadores").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(),
            );

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot doc = snapshot.data.documents[index];

              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return JogadoresDetalhes(
                          nomeJogador: doc["nome"],
                          caminhoFoto: doc["foto"] != null ? doc["foto"] : null,
                          especialidade: doc["especialidade"],
                          descricaoJogador: doc["descricao"],
                          idadeJogador: doc["idade"],
                          alturaJogador: doc["altura"],
                        );
                      }));
                    },
                    leading: ClipOval(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: doc["foto"] != null ? doc["foto"] : null,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
//                    leading: Container(
//                      height: 45.0,
//                      width: 45.0,
//                      decoration: new BoxDecoration(
//                        shape: BoxShape.circle,
//                      ),
//                      child: CachedNetworkImage(
//                        placeholder: (context, url) =>
//                            CircularProgressIndicator(),
//                        imageUrl: doc["foto"] != null ? doc["foto"] : null,
//                      ),
//                    ),
//                    leading: CircleAvatar(
//                      child: CachedNetworkImage(
//                        placeholder: (context, url) =>
//                            CircularProgressIndicator(),
//                        imageUrl: doc["foto"] != null ? doc["foto"] : null,
//                      ),
//                      backgroundColor: Colors.grey,
////                        backgroundImage: doc["foto"] != null
////                            ? NetworkImage(doc["foto"])
////                            : null
//                    ),
                    title: Text(
                      doc["nome"],
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0XFF6F5A5B)),
                    ),
                    subtitle: Text(
                      doc["especialidade"] +
                          " | " +
                          doc["idade"] +
                          " anos | " +
                          doc["altura"] +
                          " de altura",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      maxLines: 4,
                    ),
//                              trailing: GestureDetector(
//                                onTap: () {},
//                                child: Icon(Icons.edit),
//                              ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
