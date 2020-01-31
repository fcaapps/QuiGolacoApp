class Jogadores {
  String _nome;
  String _especialidade;
  String _descricao;
  String _idade;
  String _altura;
  String _caminhoFoto;
  String _dtcadastro;
  int _seq;

  Jogadores();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "especialidade": this.especialidade,
      "descricao": this.descricao,
      "idade" : this.idade,
      "altura" : this.altura,
      "foto" : this.caminhoFoto,
      "dtcadastro" : this._dtcadastro,
      "seq" : this._seq
    };
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get especialidade => _especialidade;

  set especialidade(String value) {
    _especialidade = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get idade => _idade;

  set idade(String value) {
    _idade = value;
  }

  String get altura => _altura;

  set altura(String value) {
    _altura = value;
  }

  String get caminhoFoto => _caminhoFoto;

  set caminhoFoto(String value) {
    _caminhoFoto = value;
  }

  String get dtcadastro => _dtcadastro;

  set dtcadastro(String value) {
    _dtcadastro = value;
  }

  int get seq => _seq;

  set seq(int value) {
    _seq = value;
  }

}

