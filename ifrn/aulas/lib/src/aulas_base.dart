
import 'dart:io';
import 'aula_model.dart';
import 'disciplina_model.dart';

class AulasManager {
  /// Não mudar o nome 'menu'
  static List<Map<String, dynamic>> menu = [
    { 'titulo': 'Aulas - Listar todas as aulas cadastradas', 'permissoes': null, 'metodo': Aula.listar },
    { 'titulo': 'Aulas - Cadastrar aula', 'permissoes': ['professor'], 'metodo': () => Aula.cadastrar(disciplinas: Disciplina.disciplinas) },
    { 'titulo': 'Aulas - Excluir aula', 'permissoes': ['professor'], 'metodo': Aula.excluir },
    { 'titulo': 'Aulas - Listar aula', 'permissoes': null, 'metodo': Aula.listar },
    { 'titulo': 'Aulas - Editar aula', 'permissoes': ['professor'], 'metodo': Aula.editar },

    { 'titulo': 'Aulas - Listar todas as disciplinas cadastradas', 'permissoes': null, 'metodo': Disciplina.listar },
    { 'titulo': 'Aulas - Cadastrar disciplina', 'permissoes': ['professor'], 'metodo': Disciplina.cadastrar },
    { 'titulo': 'Aulas - Excluir disciplina', 'permissoes': ['professor'], 'metodo': Disciplina.excluir },
    { 'titulo': 'Aulas - Consultar disciplina por ID', 'permissoes': null, 'metodo': Disciplina.consultar },
    { 'titulo': 'Aulas - Editar disciplina', 'permissoes': ['professor'], 'metodo': Disciplina.editar },
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
