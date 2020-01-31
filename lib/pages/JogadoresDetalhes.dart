import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quigolaco/pages/JogadoresEdit.dart';

void main() {
  runApp(MaterialApp(
    title: 'Detalhes Jogadores',
    home: JogadoresDetalhes(),
  ));
}

String idDocumento;

class JogadoresDetalhes extends StatefulWidget {
  final String nomeJogador;
  final String caminhoFoto;
  final String especialidade;
  final String descricaoJogador;
  final String idadeJogador;
  final String alturaJogador;
  final String numGols;
  final String numAssistencias;
  final String numDefesas;

  const JogadoresDetalhes(
      {Key key,
      this.nomeJogador,
      this.caminhoFoto,
      this.especialidade,
      this.descricaoJogador,
      this.idadeJogador,
      this.alturaJogador,
      this.numGols,
      this.numAssistencias,
      this.numDefesas})
      : super(key: key);

  @override
  _JogadoresDetalhesState createState() => _JogadoresDetalhesState();
}

class _JogadoresDetalhesState extends State<JogadoresDetalhes> {
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
                              caminhoFoto: this.widget.caminhoFoto,
                              nomeJogador: this.widget.nomeJogador,
                              especialidade: this.widget.especialidade,
                              descricaoJogador: this.widget.descricaoJogador,
                              idadeJogador: this.widget.idadeJogador,
                              alturaJogador: this.widget.alturaJogador,
                            )));
              },
            )
          ],
          elevation: 0,
          title: Text(
            'Sobre o ' + this.widget.nomeJogador,
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
                          imageUrl: this.widget.caminhoFoto != null
                              ? this.widget.caminhoFoto
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
                        this.widget.nomeJogador,
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
                        this.widget.especialidade,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text(
                          this.widget.descricaoJogador ?? '',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ),
                      Divider(),
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
                              Text(
                                this.widget.idadeJogador + ' anos',
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
                              Text(
                                this.widget.alturaJogador ?? '',
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'Gols:',
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
                                this.widget.numGols,
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
                                'Assist.',
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
                                this.widget.numAssistencias ?? '',
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
                                'Defesas:',
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
                                this.widget.numDefesas ?? '',
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
