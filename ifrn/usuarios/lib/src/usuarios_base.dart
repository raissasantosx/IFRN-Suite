import 'dart:io';

/// Representa um usuário do IFRN Modular Suite.
class Usuario {
  final int id;
  String nome;
  String email;
  String senha;
  DateTime dataCadastro;
  List<String> permissoes;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.dataCadastro,
    List<String>? permissoes,
  }) : permissoes = permissoes ?? [];

  /// Usuários cadastrados durante a execução do programa.
  static final List<Usuario> usuarios = [];

  /// Próximo identificador disponível.
  static int _proximoId = 1;

  /// Menu utilizado pelo programa principal.
  static final List<Map<String, dynamic>> menu = [
    {
      'titulo': 'Listar usuários',
      'permissao': null,
      'metodo': listar,
    },
    {
      'titulo': 'Cadastrar usuário',
      'permissao': 'admin',
      'metodo': cadastrar,
    },
    {
      'titulo': 'Excluir usuário',
      'permissao': 'admin',
      'metodo': excluir,
    },
  ];

  static void listar() {
    if (usuarios.isEmpty) {
      print('Nenhum usuário cadastrado.');
      return;
    }

    print('Usuários cadastrados:');

    for (final usuario in usuarios) {
      print('ID: ${usuario.id}');
      print('Nome: ${usuario.nome}');
      print('E-mail: ${usuario.email}');
      print('Data de cadastro: ${usuario.dataCadastro}');
      print('Permissões: ${usuario.permissoes.join(', ')}');
      print('------------------------------');
    }
  }

  static void cadastrar() {
    print('Digite o nome do usuário:');
    final nome = stdin.readLineSync()?.trim() ?? '';

    print('Digite o e-mail do usuário:');
    final email = stdin.readLineSync()?.trim() ?? '';

    print('Digite a senha do usuário:');
    final senha = stdin.readLineSync() ?? '';

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      print('Cadastro cancelado. Preencha todos os campos.');
      return;
    }

    final emailExiste = usuarios.any(
      (usuario) => usuario.email.toLowerCase() == email.toLowerCase(),
    );

    if (emailExiste) {
      print('Já existe um usuário cadastrado com esse e-mail.');
      return;
    }

    print('Digite as permissões separadas por vírgula.');
    print('Exemplo: admin, professor. Deixe vazio se não houver.');
    final entradaPermissoes = stdin.readLineSync() ?? '';

    final permissoes = entradaPermissoes
        .split(',')
        .map((permissao) => permissao.trim())
        .where((permissao) => permissao.isNotEmpty)
        .toSet()
        .toList();

    final usuario = Usuario(
      id: _proximoId++,
      nome: nome,
      email: email,
      senha: senha,
      dataCadastro: DateTime.now(),
      permissoes: permissoes,
    );

    usuarios.add(usuario);
    print('Usuário cadastrado com sucesso!');
  }

  static void excluir() {
    if (usuarios.isEmpty) {
      print('Não existem usuários para excluir.');
      return;
    }

    listar();

    print('Digite o ID do usuário que deseja excluir:');
    final entrada = stdin.readLineSync() ?? '';
    final id = int.tryParse(entrada);

    if (id == null) {
      print('ID inválido.');
      return;
    }

    final indice = usuarios.indexWhere((usuario) => usuario.id == id);

    if (indice == -1) {
      print('Usuário não encontrado.');
      return;
    }

    usuarios.removeAt(indice);
    print('Usuário excluído com sucesso.');
  }
}
