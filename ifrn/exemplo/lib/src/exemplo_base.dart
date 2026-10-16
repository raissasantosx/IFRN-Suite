import 'dart:io';

/// Módulo exemplo.
/// TODO: Adapte para algo específico do seu módulo.
class Exemplo {
  /// Menu de opções do módulo exemplo.
  /// TODO: Adapte ao seu módulo, mas mantenha o nome da propriedade como `menu` para que o código do binário funcione corretamente.
  static List<Map<String, dynamic>> menu = [
    { 'titulo': 'Listar todas as informações cadastradas', 'permissao': null, 'metodo': listar },
    { 'titulo': 'Cadastrar informação', 'permissao': 'admin', 'metodo': cadastrar },
    { 'titulo': 'Excluir informação', 'permissao': 'admin', 'metodo': excluir },
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
}
