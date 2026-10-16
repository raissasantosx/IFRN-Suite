
import 'dart:io';
import 'aula_model.dart';
import 'disciplina_model.dart';

class AulasManager {
  /// Não mudar o nome 'menu'
  static List<Map<String, dynamic>> menu = [
    { 'titulo': 'Listar todas as aulas cadastradas', 'permissao': null, 'metodo': Aula.listar },
    { 'titulo': 'Cadastrar aula', 'permissao': 'professor', 'metodo': () => Aula.cadastrar(disciplinas: Disciplina.disciplinas) },
    { 'titulo': 'Excluir aula', 'permissao': 'professor', 'metodo': Aula.excluir },
    { 'titulo': 'Listar aula', 'permissao': null, 'metodo': Aula.listar },
    { 'titulo': 'Editar aula', 'permissao': 'professor', 'metodo': Aula.editar },

    { 'titulo': 'Listar todas as disciplinas cadastradas', 'permissao': null, 'metodo': Disciplina.listar },
    { 'titulo': 'Cadastrar disciplina', 'permissao': 'professor', 'metodo': Disciplina.cadastrar },
    { 'titulo': 'Excluir disciplina', 'permissao': 'professor', 'metodo': Disciplina.excluir },
    { 'titulo': 'Consultar disciplina por ID', 'permissao': null, 'metodo': Disciplina.consultar },
    { 'titulo': 'Editar disciplina', 'permissao': 'professor', 'metodo': Disciplina.editar },
  ];

  static final List<String> informacoes = [];


  static void listar() {
    if (informacoes.isEmpty) {
      print('Nenhuma informação cadastrada.');
    } else {
      print('Informações cadastradas:');
      for (int i=0; i<informacoes.length; i++) {
        print('- $i: ${informacoes[i]}');
      }
    }
  }

  static void cadastrar() {
    print('Digite a informação que deseja cadastrar:');
    String? input = stdin.readLineSync();
    if (input != null && input.isNotEmpty) {
      informacoes.add(input);
      print('Informação cadastrada.');
    } else {
      print('Nenhuma informação foi cadastrada.');
    }
  }

  static void excluir() {
    print('Digite a informação que deseja excluir:');
    String? input = stdin.readLineSync() ?? '';
    int? index = int.tryParse(input);
    if (index != null && index >= 0 && index < informacoes.length) {
      informacoes.removeAt(index);
      print('Informação excluída com sucesso.');
    } else {
      print('Informação não encontrada.');
    }
  }

  static void editar(List<String> informacoes) {
  print('Digite o índice da informação que deseja editar:');

    String? input = stdin.readLineSync() ?? '';
    int? index = int.tryParse(input);

    if (index != null && index >= 0 && index < informacoes.length) {
      print('Digite a nova informação:');

      String novaInformacao = stdin.readLineSync() ?? '';

      informacoes[index] = novaInformacao;

      print('Informação editada com sucesso.');
    } else {
      print('Informação não encontrada.');
    }
  }
}
