
class Usuario {

  String _nome;
  String _email;
  String _senha;

  Usuario();

  String get senha => _senha;

  set setSenha(String value) {
    _senha = value;
  }

  String get email => _email;

  set setEmail(String value) {
    _email = value;
  }

  String get nome => _nome;

  set setNome(String value) {
    _nome = value;
  }


}