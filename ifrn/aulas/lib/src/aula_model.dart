
import 'dart:io';

import 'package:aulas/src/disciplina_model.dart';

class Aula {
  final int id;
  final Disciplina disciplina;
  final int quantidade;
  final String data;

  static final List<Aula> aulasArray = [];
  static int _proximoId = 1;

  Aula({
    required this.id,
    required this.disciplina,
    required this.quantidade,
    required this.data,
  });

  static void listar() {
    if (aulasArray.isEmpty) {
      print('Nenhuma aula foi cadastrada ainda.');
      return;
    }
    print('Aulas cadastradas:');
    for (var i = 0; i < aulasArray.length; i++) {
      final a = aulasArray[i];
      print('[$i] id=${a.id} disciplina=${a.disciplina.nome} quantidade=${a.quantidade} data=${a.data}');
    }
  }

  static void cadastrar({required List<Disciplina> disciplinas}) {
    print('Digite o id da disciplina:');
    final disciplinaIdStr = stdin.readLineSync()?.trim() ?? '';
    final disciplinaId = int.tryParse(disciplinaIdStr);

    Disciplina? disciplina;
    if (disciplinaId != null) {
      for (final d in disciplinas) {
        if (d.id == disciplinaId) {
          disciplina = d;
          break;
        }
      }
    }

    if (disciplina == null) {
      print('Disciplina não encontrada. Cadastro cancelado.');
      return;
    }

    print('Digite a quantidade de aulas:');
    final quantidadeStr = stdin.readLineSync()?.trim() ?? '';
    final quantidade = int.tryParse(quantidadeStr);
    if (quantidade == null || quantidade <= 0) {
      print('Quantidade inválida. Cadastro cancelado.');
      return;
    }

    print('Digite a data da aula (ou ENTER para usar agora):');
    final dataStr = stdin.readLineSync()?.trim() ?? '';
    final data = dataStr.isEmpty ? DateTime.now().toIso8601String() : dataStr;

    final aula = Aula(
      id: _proximoId++,
      disciplina: disciplina,
      quantidade: quantidade,
      data: data,
    );

    aulasArray.add(aula);
    print('Aula cadastrada com id=${aula.id}.');
  }

  static void excluir() {
    print('Digite o índice da aula que deseja excluir:');
    final input = stdin.readLineSync() ?? '';
    final index = int.tryParse(input);
    if (index != null && index >= 0 && index < aulasArray.length) {
      aulasArray.removeAt(index);
      print('Aula excluída com sucesso.');
    } else {
      print('Índice inválido. Nenhuma aula removida.');
    }
  }

  static void editar() {
    print('Digite o índice da aula que deseja editar:');
    final input = stdin.readLineSync() ?? '';
    final index = int.tryParse(input);

    if (index == null || index < 0 || index >= aulasArray.length) {
      print('Índice inválido.');
      return;
    }

    final antiga = aulasArray[index];

    print('Digite a nova quantidade (atual: ${antiga.quantidade}):');
    final qStr = stdin.readLineSync() ?? '';
    final novaQuantidade = int.tryParse(qStr);
    if (novaQuantidade == null || novaQuantidade <= 0) {
      print('Quantidade inválida. Edição cancelada.');
      return;
    }

    print('Digite a nova data (ou ENTER para manter (${antiga.data})):');
    final dStr = stdin.readLineSync()?.trim() ?? '';
    final novaData = dStr.isEmpty ? antiga.data : dStr;

    aulasArray[index] = Aula(
      id: antiga.id,
      disciplina: antiga.disciplina,
      quantidade: novaQuantidade,
      data: novaData,
    );

    print('Aula editada com sucesso.');
  }
}