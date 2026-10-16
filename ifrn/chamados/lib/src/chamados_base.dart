import 'dart:io';
import 'package:usuarios/usuarios.dart';

// Classe de usuário que herda da classe de usuári odo grupo 1 (Marcos)
class UsuarioChamado extends Usuario {
  final int matricula;
  final String campus;

  UsuarioChamado({
    required super.id,
    required super.nome,
    required super.email,
    required super.dataCadastro,
    required this.matricula,
    required super.senha,
    required this.campus,
    List<String>? permissoes
  });
}

class Chamado {
  final int id;
  String descricao;
  final String campus;
  List<String> interessados;
  final String status;

  static List<Chamado> instancias = [];

  Chamado({
    required this.id,
    required this.descricao,
    required this.campus,
    required this.interessados,
    this.status = 'Pendente'
  }) {
    instancias.add(this);
  }
}

class ChamadoController {
  static List<Map<String, dynamic>> menu = [
    { 'titulo': 'Chamados - Listar chamados', 'permissao': null, 'metodo': listar },
    { 'titulo': 'Chamados - Abrir chamado', 'permissao': null, 'metodo': cadastrar },
    { 'titulo': 'Chamados - Fechar chamado', 'permissao': null, 'metodo': excluir },
    { 'titulo': 'Chamados - Editar chamado', 'permissao': null, 'metodo': editar },
  ];

  static void listar() {
    if (Chamado.instancias.isEmpty) {
      print('Você não possui chamados registrados.');
    } else {
      for (final chamado in Chamado.instancias) {
        String textoInteressados = '\n';
        for (final usuario in chamado.interessados) {
          textoInteressados += '$usuario\n';
        }

        print('''
        -------------------
        ${chamado.descricao} (${chamado.status})
        Campus: ${chamado.campus}
        Interessados: $textoInteressados
        -------------------
        ''');
      }
    }
  }

  static void cadastrar() {
    print('Insira um campus para o chamado:');
    String? campus = stdin.readLineSync();
    if (campus == null) {
      print('É preciso informar um campus para abrir chamado.');
      return;
    }

    print('Insira a descrição do chamado');
    String descricao = stdin.readLineSync() ?? 'Sem descrição';

    print('Insira o nome dos interessados, separados por vírgula:');
    String? interessadosTexto = stdin.readLineSync();
    List<String> interessados = [];
    if (interessadosTexto != null) {
      interessados = interessadosTexto.trim().split(',');
    }

    Chamado(
      id: Chamado.instancias.length + 1,
      descricao: descricao,
      campus: campus,
      interessados: interessados
    );
  }

  static void excluir() {
    print('Insira o id do chamado que deseja fechar:');
    int? id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null) {
      print('Valor inválido digitado.');
      return;
    }
    for (final chamado in Chamado.instancias) {
      if (chamado.id == id) {
        Chamado.instancias.remove(chamado);
        print('Chamado fechado com sucesso.');
        return;
      }
    }
    print('Nenhum chamado com este id foi encontrado.');
    return;
  }

  static void editar() {
    print('Insira o id do chamado que deseja editar:');
    int? id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null) {
      print('Valor inválido digitado.');
      return;
    }
    for (final chamado in Chamado.instancias) {
      if (chamado.id == id) {
        print('Deseja alterar a descrição (s/n)?');
        String? opcao = stdin.readLineSync();
        if (opcao == 's') {
          print('Insira a nova descrição:');
          String? novaDescricao = stdin.readLineSync();
          if (novaDescricao == null) {
            chamado.descricao = 'Sem descrição';
          } else {
            chamado.descricao = novaDescricao;
          }
        } else if (opcao != 'n') {
          print('Opção inválida digitada.');
          return;
        }
        print('Deseja alterar a lista de interessados (s/n)?');
        opcao = stdin.readLineSync();
        if (opcao == 's') {
          print('Insira o nome dos interessados, separados por vírgula:');
          String? interessadosTexto = stdin.readLineSync();
          if (interessadosTexto != null) {
            List<String> interessados = interessadosTexto.trim().split(',');
            chamado.interessados = interessados;
          }
          return;
        } else if (opcao != 'n') {
          print('Opção inválida digitada.');
          return;
        }
      }
    }
    print('Nenhum chamado com este id foi encontrado.');
    return;
  }
}