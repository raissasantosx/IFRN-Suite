import 'dart:io';

import 'item.dart';
import 'retirada.dart';
import 'almoxarifado_base.dart';

/// Regras de negócio e interface do módulo de retiradas.
class Retiradas {
  static const List<String> perfisPermitidos = [
    'professor',
    'tecnico_administrativo',
  ];

  static final List<Retirada> registros = [];
  static int _proximoId = 1;

  /// Verifica se o perfil pode efetuar retiradas.
  static bool temPermissao(String perfil) {
    return perfisPermitidos.contains(_normalizarPerfil(perfil));
  }

  static String _normalizarPerfil(String perfil) {
    return perfil
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c')
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
  }

  /// Registra uma retirada e atualiza o estoque.
  ///
  /// Lança [UnauthorizedError] para perfis não autorizados e
  /// [RetiradaInvalidaError] para quantidade, item ou estoque inválidos.
  static Retirada registrar({
    required Item item,
    required int quantidade,
    required String solicitante,
    required String perfil,
  }) {
    if (!temPermissao(perfil)) {
      throw UnauthorizedError(
        'Acesso negado: somente professores e técnicos-administrativos '
        'podem efetuar retiradas.',
      );
    }

    if (solicitante.trim().isEmpty) {
      throw RetiradaInvalidaError('O nome do solicitante é obrigatório.');
    }

    if (quantidade <= 0) {
      throw RetiradaInvalidaError('A quantidade deve ser maior que zero.');
    }

    if (!Almoxarifado.itens.contains(item)) {
      throw RetiradaInvalidaError('O item não pertence ao almoxarifado.');
    }

    if (quantidade > item.quantidadeDisponivel) {
      throw RetiradaInvalidaError(
        'Estoque insuficiente. Disponível: ${item.quantidadeDisponivel}.',
      );
    }

    final retirada = Retirada(
      id: _proximoId,
      item: item,
      quantidade: quantidade,
      solicitante: solicitante.trim(),
      perfilSolicitante: _normalizarPerfil(perfil),
    );

    // A alteração de estoque só ocorre depois de todas as validações.
    item.quantidadeDisponivel -= quantidade;
    registros.add(retirada);
    _proximoId++;

    return retirada;
  }

  static List<Map<String, dynamic>> menu({
    required String nomeUsuario,
    required String perfilUsuario,
  }) {
    return [
      {
        'titulo': 'Efetuar retirada de item',
        'perfisPermitidos': perfisPermitidos,
        'metodo': () => efetuarRetirada(
          nomeUsuario: nomeUsuario,
          perfilUsuario: perfilUsuario,
        ),
      },
      {
        'titulo': 'Listar retiradas realizadas',
        'perfisPermitidos': perfisPermitidos,
        'metodo': listar,
      },
    ];
  }

  static void efetuarRetirada({
    required String nomeUsuario,
    required String perfilUsuario,
  }) {
    if (!temPermissao(perfilUsuario)) {
      print(
        'Acesso negado. Somente professores e técnicos-administrativos '
        'podem efetuar retiradas.',
      );
      return;
    }

    if (Almoxarifado.itens.isEmpty) {
      print('Não há itens cadastrados no almoxarifado.');
      return;
    }

    print('Itens disponíveis:');
    for (final item in Almoxarifado.itens) {
      print(
        'ID: ${item.id} | ${item.nome} | Categoria: ${item.categoria} | '
        'Estoque: ${item.quantidadeDisponivel}',
      );
    }

    stdout.write('Digite o ID do item: ');
    final id = int.tryParse(stdin.readLineSync()?.trim() ?? '');
    if (id == null) {
      print('ID inválido.');
      return;
    }

    Item? itemSelecionado;
    for (final item in Almoxarifado.itens) {
      if (item.id == id) {
        itemSelecionado = item;
        break;
      }
    }

    if (itemSelecionado == null) {
      print('Item não encontrado.');
      return;
    }

    stdout.write('Digite a quantidade para retirada: ');
    final quantidade = int.tryParse(stdin.readLineSync()?.trim() ?? '');
    if (quantidade == null) {
      print('Quantidade inválida.');
      return;
    }

    try {
      final retirada = registrar(
        item: itemSelecionado,
        quantidade: quantidade,
        solicitante: nomeUsuario,
        perfil: perfilUsuario,
      );
      print(
        'Retirada #${retirada.id} registrada. '
        '${retirada.quantidade} unidade(s) de ${retirada.item.nome}. '
        'Estoque restante: ${retirada.item.quantidadeDisponivel}.',
      );
    } on UnauthorizedError catch (erro) {
      print(erro.message);
    } on RetiradaInvalidaError catch (erro) {
      print(erro.message);
    }
  }

  static void listar() {
    if (registros.isEmpty) {
      print('Nenhuma retirada registrada.');
      return;
    }

    print('Retiradas realizadas:');
    for (final retirada in registros) {
      print(
        '#${retirada.id} | Item: ${retirada.item.nome} | '
        'Quantidade: ${retirada.quantidade} | '
        'Solicitante: ${retirada.solicitante} | '
        'Perfil: ${retirada.perfilSolicitante} | '
        'Data: ${retirada.data.toLocal()}',
      );
    }
  }
}

class UnauthorizedError implements Exception {
  final String message;
  UnauthorizedError(this.message);

  @override
  String toString() => message;
}

class RetiradaInvalidaError implements Exception {
  final String message;
  RetiradaInvalidaError(this.message);

  @override
  String toString() => message;
}
