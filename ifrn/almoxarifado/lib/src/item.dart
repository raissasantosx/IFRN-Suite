class Item {
  final int id;
  String nome;
  String categoria;

  /// Quantidade disponível para retirada no estoque.
  int quantidadeDisponivel;

  Item({
    required this.id,
    required this.nome,
    required this.categoria,
    this.quantidadeDisponivel = 0,
  });
}
