import 'item.dart';

/// Registra a retirada de uma quantidade de um item do almoxarifado.
class Retirada {
  final int id;
  final Item item;
  final int quantidade;
  final String solicitante;
  final String perfilSolicitante;
  final DateTime data;

  Retirada({
    required this.id,
    required this.item,
    required this.quantidade,
    required this.solicitante,
    required this.perfilSolicitante,
    DateTime? data,
  }) : data = data ?? DateTime.now();
}
