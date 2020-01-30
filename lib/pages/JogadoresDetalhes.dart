import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quigolaco/pages/JogadoresEdit.dart';

void main() {
  runApp(MaterialApp(
    title: 'Detalhes Jogadores',
    home: JogadoresDetalhes(),
  ));
}

class JogadoresDetalhes extends StatelessWidget {
  final String nomeJogador;
  final String caminhoFoto;
  final String especialidade;
  final String descricaoJogador;
  final String idadeJogador;
  final String alturaJogador;

  const JogadoresDetalhes(
      {Key key,
      this.nomeJogador,
      this.caminhoFoto,
      this.especialidade,
      this.descricaoJogador,
      this.idadeJogador,
      this.alturaJogador})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JogadoresEdit(
                            caminhoFoto: caminhoFoto,
                            nomeJogador: nomeJogador,
                            especialidade: especialidade,
                            descricaoJogador: descricaoJogador,
                            idadeJogador: idadeJogador,
                            alturaJogador: alturaJogador,
                          )));
            },
          )
        ],
        elevation: 0,
        title: Text(
          'Sobre o $nomeJogador',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0XFF4E7CA0),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 120,
              decoration: BoxDecoration(
                  color: Color(0XFF4E7CA0),
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
                        imageUrl: caminhoFoto != null
                            ? caminhoFoto
                            : null,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
//                  child: Center(
//                    child: CircleAvatar(
//                      radius: 56,
//                      backgroundColor: Colors.grey,
//                      backgroundImage: caminhoFoto != null
//                          ? NetworkImage(caminhoFoto)
//                          : null,
//                    ),
//                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 190, left: 30, right: 30),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Text(
                      nomeJogador,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color(0XFF4A3949)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Especialidade:',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0XFFCAA772)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      especialidade,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey),
                    ),
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
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Colors.grey, blurRadius: 2)
                          ]),
                      child: Text(
                        descricaoJogador ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey),
                      ),
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
                            Text(
                              '$idadeJogador anos',
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
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
                            Text(
                              alturaJogador ?? '',
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )),
          ],
        ),
      )
    );
  }
}
