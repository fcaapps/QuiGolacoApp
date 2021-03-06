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

//  Future<List<Jogadores>> listarJogadores() async {
//    QuerySnapshot querySnapshot =
//        await db.collection("jogadores").orderBy("seq", descending: true).getDocuments();
//
//    List<Jogadores> listaJogadores = List();
//
//    for (DocumentSnapshot item in querySnapshot.documents) {
//      var dados = item.data;
//      print(dados);
//
//      Jogadores jogadores = Jogadores();
//
//      jogadores.nome = dados["nome"];
//      jogadores.especialidade = dados["especialidade"];
//      jogadores.descricao = dados["descricao"];
//      jogadores.idade = dados["idade"];
//      jogadores.altura = dados["altura"];
//      jogadores.caminhoFoto = dados["foto"];
//      jogadores.dtcadastro = dados["dtcastro"];
//      jogadores.seq = dados["seq"];
//
//      listaJogadores.add(jogadores);
//    }
//    return listaJogadores;
//  }
//
//  Future<List> listarJogadores2() async {
//    QuerySnapshot querySnapshot =
//    await db.collection("jogadores").orderBy("seq", descending: true).getDocuments();
//
//    List lista = List();
//
//    for (DocumentSnapshot item in querySnapshot.documents) {
//      var dados = item.data;
//      print(dados);
//
//      lista.add({
//        "nome" : dados["nome"],
//        "especialidade" : dados["especialidade"],
//        "descricao" : dados["descricao"],
//        "idade" : dados["idade"],
//        "altura" : dados["altura"],
//        "caminhoFoto" : dados["caminhoFoto"],
//        "dtcadastro" : dados["dtcadastro"],
//        "seq" : dados["seq"]
//
//      });
//    }
//    return lista;
//  }

  @override
  void initState() {
    //listarJogadores();

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
    String nomefoto =
        (DateFormat('yyyyMMddHms').format(DateTime.now())).toString() + ".jpg";

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
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

  String numGols;
  String numAssistencias;
  String numDefesas;

  Future _recuperaGols(String nomeJogador) async {
    QuerySnapshot querySnapshotGols = await db
        .collection("jogadores")
        .document(nomeJogador)
        .collection("gols")
        .getDocuments();

    int numG = 0;
    querySnapshotGols.documents.forEach((d) {
      numG += int.parse(d.data["numGols"]);
      print("laço: " + numG.toString());
    });

    numGols = numG.toString();

    print("numGols Interno: " + numGols);
  }

  Future _recuperarGAD(String nomeJogador) async {
//
//    var ref = db
//        .collection("jogadores")
//        .where("nome", isEqualTo: nomeJogador)
//        .getDocuments();
//
//    ref.then((v) {
//      idDocumento = v.documents[0].documentID;
//      print(idDocumento);
//    });

    //Gols
    QuerySnapshot querySnapshotGols = await db
        .collection("jogadores")
        .document(nomeJogador)
        .collection("gols")
        .getDocuments();

    int numG = 0;
    querySnapshotGols.documents.forEach((d) {
      numG += int.parse(d.data["numGols"]);
    });

    numGols = numG.toString();

    //Assistencias
    QuerySnapshot querySnapshotAssist = await db
        .collection("jogadores")
        .document(nomeJogador)
        .collection("assistencias")
        .getDocuments();

    int numA = 0;
    querySnapshotAssist.documents.forEach((d) {
      numA += int.parse(d.data["numAssistencias"]);
    });

    numAssistencias = numA.toString();

    //Defesas
    QuerySnapshot querySnapshotDefesas = await db
        .collection("jogadores")
        .document(nomeJogador)
        .collection("defesas")
        .getDocuments();

    int numD = 0;
    querySnapshotDefesas.documents.forEach((d) {
      numD += int.parse(d.data["numDefesas"]);
    });

    numDefesas = numD.toString();
  }

  String ordem = "seq";
  bool isDescending = true;

  @override
  Widget build(BuildContext context) {
    loadEspecialidade();

    return Material(
        child: Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              'JOGADORES',
              style: TextStyle(
                fontFamily: 'Raleway'
              ),
            )
          ],
        ),
        actions: <Widget>[
          Visibility(
            child: IconButton(
              onPressed: () {
                setState(() {
                  ordem = "nome";
                  isDescending = false;
                });
              },
              icon: Icon(Icons.sort_by_alpha),
              tooltip: 'Ordem de Nome',
            ),
          ),
          Visibility(
            child: IconButton(
              onPressed: () {
                setState(() {
                  ordem = "seq";
                  isDescending = true;
                });
              },
              icon: Icon(Icons.sort),
              tooltip: 'Ordem de Cadastro',
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: db
            .collection("jogadores")
            .orderBy(ordem, descending: isDescending)
            .snapshots(),
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
                    onTap: () async {
                      await _recuperarGAD(doc["nome"]);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return JogadoresDetalhes(
                          nomeJogador: doc["nome"],
                          caminhoFoto: doc["foto"] != null ? doc["foto"] : null,
                          especialidade: doc["especialidade"],
                          descricaoJogador: doc["descricao"],
                          idadeJogador: doc["idade"],
                          alturaJogador: doc["altura"],
                          numGols: numGols ?? '0',
                          numAssistencias: numAssistencias ?? '0',
                          numDefesas: numDefesas ?? '0',
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
                    title: Text(
                      doc["nome"],
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0XFF6F5A5B)),
                    ),
                    subtitle: Text(
                      doc["descricao"],
                      textAlign: TextAlign.start,
//                    subtitle: Text(
//                      "Especialidade: " + doc["especialidade"] +
//                          " | " +
//                          doc["idade"] +
//                          " anos | " +
//                          doc["altura"] +
//                          " de altura",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      maxLines: 2,
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
    ));
  }
}
