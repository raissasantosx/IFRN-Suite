import 'dart:io';

import 'item.dart';

class Almoxarifado {
  static List<Map<String, dynamic>> menu = [
    {
      'titulo': 'Listar itens do almoxarifado',
      'perfisPermitidos': null,
      'metodo': listar,
    },
    {
      'titulo': 'Cadastrar item',
      'permissao': 'admin',
      'metodo': cadastrar,
    },
    {
      'titulo': 'Atualizar item',
      'permissao': 'admin',
      'metodo': atualizar,
    },
    {
      'titulo': 'Excluir item',
      'permissao': 'admin',
      'metodo': excluir,
    },
  ];

  static final List<Item> itens = [];
  static int proximoId = 1;

  // READ - Listar
  static void listar() {
    if (itens.isEmpty) {
      print('Nenhum item cadastrado.');
      return;
    }

    print('Itens cadastrados:');
    for (final item in itens) {
      print(
        'ID: ${item.id} | Nome: ${item.nome} | '
        'Categoria: ${item.categoria} | '
        'Estoque: ${item.quantidadeDisponivel}',
      );
    }
  }

  // CREATE - Cadastrar
  static void cadastrar() {
    stdout.write('Digite o nome do item: ');
    final nome = stdin.readLineSync()?.trim() ?? '';

    stdout.write('Digite a categoria do item: ');
    final categoria = stdin.readLineSync()?.trim() ?? '';

    stdout.write('Digite a quantidade inicial em estoque: ');
    final quantidade = int.tryParse(stdin.readLineSync()?.trim() ?? '');

    if (nome.isEmpty || categoria.isEmpty) {
      print('Nome e categoria são obrigatórios.');
      return;
    }
    if (quantidade == null || quantidade < 0) {
      print('A quantidade deve ser um número inteiro maior ou igual a zero.');
      return;
    }

    itens.add(Item(
      id: proximoId,
      nome: nome,
      categoria: categoria,
      quantidadeDisponivel: quantidade,
    ));
    proximoId++;
    print('Item cadastrado com sucesso!');
  }

  // READ - Buscar pelo nome
  static Item? buscarPorNome(String nomeBusca) {
    for (final item in itens) {
      if (item.nome.toLowerCase() == nomeBusca.toLowerCase()) {
        return item;
      }
    }
    return null;
  }

  // UPDATE - Atualizar
  static void atualizar() {
    stdout.write('Digite o nome do item que deseja atualizar: ');
    final nomeBusca = stdin.readLineSync()?.trim() ?? '';

    if (nomeBusca.isEmpty) {
      print('Nome inválido.');
      return;
    }

    final item = buscarPorNome(nomeBusca);
    if (item == null) {
      print('Item não encontrado!');
      return;
    }

    stdout.write('Digite o novo nome do item: ');
    final nome = stdin.readLineSync()?.trim() ?? '';
    stdout.write('Digite a nova categoria do item: ');
    final categoria = stdin.readLineSync()?.trim() ?? '';
    stdout.write('Digite a nova quantidade em estoque: ');
    final quantidade = int.tryParse(stdin.readLineSync()?.trim() ?? '');

    if (nome.isEmpty || categoria.isEmpty) {
      print('Nome e categoria são obrigatórios.');
      return;
    }
    if (quantidade == null || quantidade < 0) {
      print('A quantidade deve ser um número inteiro maior ou igual a zero.');
      return;
    }

    item.nome = nome;
    item.categoria = categoria;
    item.quantidadeDisponivel = quantidade;
    print('Item atualizado com sucesso!');
  }

  // DELETE - Excluir
  static void excluir() {
    stdout.write('Digite o nome do item que deseja excluir: ');
    final nomeBusca = stdin.readLineSync()?.trim() ?? '';

    if (nomeBusca.isEmpty) {
      print('Nome inválido.');
      return;
    }

    final item = buscarPorNome(nomeBusca);
    if (item == null) {
      print('Item não encontrado.');
      return;
    }

    itens.remove(item);
    print('Item excluído com sucesso!');
  }
}
