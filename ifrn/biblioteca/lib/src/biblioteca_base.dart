import 'dart:io';

import 'package:usuarios/usuarios.dart';

/// Módulo exemplo.
/// TODO: Adapte para algo específico do seu módulo.

class UsuarioBiblioteca {
  Usuario usuario;
  List<Emprestimo> livrosEmprestados = [];
  
  UsuarioBiblioteca(this.usuario);
}

class Livro{
  String titulo;
  String autor;
  bool disponivel;

  Livro (this.titulo, this.autor, this.disponivel);
}

class Emprestimo {
  Livro livro;
  DateTime dataEmprestimo;
  DateTime dataDevolucao;

  Emprestimo(this.livro, this.dataEmprestimo, this.dataDevolucao);
}

class Devolucao {
  Livro livro;
  DateTime dataDevolucao;

  Devolucao(this.livro, this.dataDevolucao);
}

class Biblioteca {
  /// Menu de opções do módulo exemplo.
  /// TODO: Adapte ao seu módulo, mas mantenha o nome da propriedade como `menu` para que o código do binário funcione corretamente.
  static List<Map<String, dynamic>> menu = [
    { 'titulo': 'Biblioteca - Cadastrar livro', 'permissao': 'bibliotecario', 'metodo': cadastrarLivro },
    { 'titulo': 'Biblioteca - Listar livros', 'permissao': null, 'metodo': listarLivros },
    { 'titulo': 'Biblioteca - Registrar emprestimo ', 'permissao': 'bibliotecario', 'metodo': registrarEmprestimo },
    { 'titulo': 'Biblioteca - Listar emprestimos', 'permissao': null, 'metodo': listarEmprestimos },
    { 'titulo': 'Biblioteca - Registrar devolução', 'permissao': 'bibliotecario', 'metodo': registrarDevolucao },
    { 'titulo': 'Biblioteca - Listar devoluções', 'permissao': null, 'metodo': listarDevolucoes },
    { 'titulo': 'Biblioteca - Excluir livro', 'permissao': 'bibliotecario', 'metodo': excluir },
  ];

  static final List<Livro> livros = [];
  static final List<Emprestimo> emprestimos = [];
  static final List<Devolucao> devolucoes = [];


static void cadastrarLivro() {
    print('Digite o titulo do livro: ');
    String? titulo = stdin.readLineSync();
    print('Digite o autor do livro: ');
    String? autor = stdin.readLineSync();
    print('Digite se o livro está disponível (S/N): ');
    String? disponivel = stdin.readLineSync();
    
    if (titulo != null && titulo.isNotEmpty && autor != null && autor.isNotEmpty && disponivel != null && disponivel.isNotEmpty) {
      var livro = Livro(titulo, autor, disponivel[0].toLowerCase() == "s");
      livros.add(livro);
      print('Livro cadastrado.');
    } else {
      print('Nenhum livro foi cadastrado.');
    }
  }

  static void listarLivros() {
    if (livros.isEmpty) {
      print('Nenhum livro cadastrado.');
    } else {
      print('livros cadastrados:');
      for (int i=0; i<livros.length; i++) {
        print('- $i: ${livros[i].titulo},''- $i: ${livros[i].autor},');
      }
    }
  }

  static void registrarEmprestimo() {
    print('Digite o título do livro que deseja emprestar:');
    String? titulo = stdin.readLineSync();
    Livro? livro = livros.firstWhere((l) => l.titulo == titulo, orElse: () => Livro('', '', false));
    if ( titulo!= null && titulo.isNotEmpty) {
      emprestimos.add(Emprestimo(livro, DateTime.now(), DateTime.now().add(Duration(days: 15))));
      print('Livro emprestado.');
    } else {
      print('Nenhum livro foi emprestado.');
    }
  }


  static void listarEmprestimos() {
    if (emprestimos.isEmpty) {
      print('Nenhum empréstimo registrado.');
    } else {
      print('Empréstimos registrados:');
      for (int i=0; i<emprestimos.length; i++) {
        print('- $i: ${emprestimos[i].livro.titulo}, Data do empréstimo: ${emprestimos[i].dataEmprestimo}, Data da devolução: ${emprestimos[i].dataDevolucao}');
      }
    }
  }
     
  static void registrarDevolucao() {
    print('Digite o título do livro que deseja devolver:');
    String? titulo = stdin.readLineSync();
    Livro? livro = livros.firstWhere((l) => l.titulo == titulo, orElse: () => Livro('', '', false));
    if ( titulo!= null && titulo.isNotEmpty) {
      emprestimos.removeWhere((e) => e.livro == livro);
      devolucoes.add(Devolucao(livro, DateTime.now()));
      print('Livro devolvido.');
    } else {
      print('Nenhum livro foi devolvido.');
    }
  }

  static void listarDevolucoes() {
    if (devolucoes.isEmpty) {
      print('Nenhuma devolução registrada.');
    } else {
      print('Devoluções registradas:');
      for (int i=0; i<devolucoes.length; i++) {
        print('- $i: ${devolucoes[i].livro.titulo}, Data da devolução: ${devolucoes[i].dataDevolucao}');
      }
    }
  }

  static void excluir() {
    print('Digite o título do livro que deseja excluir:');
    String? titulo = stdin.readLineSync();
    Livro? livro = livros.firstWhere((l) => l.titulo == titulo, orElse: () => Livro('', '', false));
    if ( titulo!= null && titulo.isNotEmpty) {
      livros.remove(livro);
      print('Livro excluído.');
    } else {
      print('Nenhum livro foi excluído.');
    }
  }
}
