import 'utilitarios.dart';

/// Cardápio do refeitório para um determinado dia (classe MENU do diagrama).
class Menu {
  /// Identificador único do cardápio.
  final int id;

  /// Dia em que o cardápio será servido.
  DateTime data;

  /// Prato principal (ex.: "Arroz e feijão").
  String pratoPrincipal;

  /// Acompanhamento do prato principal.
  String acompanhamento;

  /// Bebida servida.
  String bebida;

  /// Sobremesa servida.
  String sobremesa;

  Menu({
    required this.id,
    required this.data,
    required this.pratoPrincipal,
    required this.acompanhamento,
    required this.bebida,
    required this.sobremesa,
  });

  /// Cardápios cadastrados durante a execução do programa.
  static final List<Menu> menus = [];

  /// Próximo identificador disponível.
  static int _proximoId = 1;

  @override
  String toString() =>
      'ID: $id | ${formatarData(data)} | Prato principal: $pratoPrincipal | '
      'Acompanhamento: $acompanhamento | Bebida: $bebida | '
      'Sobremesa: $sobremesa';

  // ---------------------------------------------------------------------
  // Regras de negócio (sem leitura de teclado, para poderem ser testadas)
  // ---------------------------------------------------------------------

  /// Cria e registra um cardápio. Lança [ArgumentError] se algum campo de
  /// texto for vazio ou não tiver nenhuma letra (ex.: "123") e [StateError]
  /// se já houver cardápio na data.
  static Menu registrar({
    required DateTime data,
    required String pratoPrincipal,
    required String acompanhamento,
    required String bebida,
    required String sobremesa,
  }) {
    if (!textoValido(pratoPrincipal) ||
        !textoValido(acompanhamento) ||
        !textoValido(bebida) ||
        !textoValido(sobremesa)) {
      throw ArgumentError(
        'Prato, acompanhamento, bebida e sobremesa devem ser preenchidos '
        'com texto (com pelo menos uma letra).',
      );
    }
    if (buscarPorData(data) != null) {
      throw StateError('Já existe um cardápio cadastrado para essa data.');
    }
    final menu = Menu(
      id: _proximoId++,
      data: DateTime(data.year, data.month, data.day),
      pratoPrincipal: pratoPrincipal.trim(),
      acompanhamento: acompanhamento.trim(),
      bebida: bebida.trim(),
      sobremesa: sobremesa.trim(),
    );
    menus.add(menu);
    return menu;
  }

  /// Busca um cardápio pelo ID. Retorna `null` se não existir.
  static Menu? buscarPorId(int id) {
    for (final menu in menus) {
      if (menu.id == id) return menu;
    }
    return null;
  }

  /// Busca o cardápio de uma data. Retorna `null` se não existir.
  static Menu? buscarPorData(DateTime data) {
    for (final menu in menus) {
      if (mesmoDia(menu.data, data)) return menu;
    }
    return null;
  }

  /// Atualiza apenas os campos informados (`null` ou vazio mantém o valor
  /// atual). Retorna `false` se o cardápio não existir. Lança [StateError] se
  /// a nova data já pertencer a outro cardápio e [ArgumentError] se algum
  /// texto informado não tiver nenhuma letra. Nada é alterado em caso de erro.
  static bool atualizarMenu(
    int id, {
    DateTime? data,
    String? pratoPrincipal,
    String? acompanhamento,
    String? bebida,
    String? sobremesa,
  }) {
    final menu = buscarPorId(id);
    if (menu == null) return false;

    final textos = [pratoPrincipal, acompanhamento, bebida, sobremesa];
    for (final texto in textos) {
      if (texto != null && texto.trim().isNotEmpty && !textoValido(texto)) {
        throw ArgumentError('Os textos devem conter pelo menos uma letra.');
      }
    }

    if (data != null) {
      final outro = buscarPorData(data);
      if (outro != null && outro.id != id) {
        throw StateError('Já existe um cardápio cadastrado para essa data.');
      }
      menu.data = DateTime(data.year, data.month, data.day);
    }
    if (pratoPrincipal != null && pratoPrincipal.trim().isNotEmpty) {
      menu.pratoPrincipal = pratoPrincipal.trim();
    }
    if (acompanhamento != null && acompanhamento.trim().isNotEmpty) {
      menu.acompanhamento = acompanhamento.trim();
    }
    if (bebida != null && bebida.trim().isNotEmpty) {
      menu.bebida = bebida.trim();
    }
    if (sobremesa != null && sobremesa.trim().isNotEmpty) {
      menu.sobremesa = sobremesa.trim();
    }
    return true;
  }

  /// Remove um cardápio pelo ID. Retorna `false` se não existir.
  static bool removerMenu(int id) {
    final indice = menus.indexWhere((menu) => menu.id == id);
    if (indice == -1) return false;
    menus.removeAt(indice);
    return true;
  }

  // ---------------------------------------------------------------------
  // Operações interativas (usadas no menu do programa principal)
  // ---------------------------------------------------------------------

  /// Cadastra um novo cardápio lendo os dados do teclado.
  static void cadastrar() {
    final data = converterData(lerLinha('Digite a data (dd/mm/aaaa):'));
    if (data == null) {
      print('Data inválida. Cadastro cancelado.');
      return;
    }
    final prato = lerLinha('Digite o prato principal:');
    final acompanhamento = lerLinha('Digite o acompanhamento:');
    final bebida = lerLinha('Digite a bebida:');
    final sobremesa = lerLinha('Digite a sobremesa:');

    try {
      registrar(
        data: data,
        pratoPrincipal: prato,
        acompanhamento: acompanhamento,
        bebida: bebida,
        sobremesa: sobremesa,
      );
      print('Cardápio cadastrado com sucesso!');
    } on ArgumentError catch (e) {
      print('Cadastro cancelado. ${e.message}');
    } on StateError catch (e) {
      print('Cadastro cancelado. ${e.message}');
    }
  }

  /// Exibe os cardápios cadastrados (em ordem de data) e os retorna.
  static List<Menu> listar() {
    final ordenados = List<Menu>.from(menus)
      ..sort((a, b) => a.data.compareTo(b.data));

    if (ordenados.isEmpty) {
      print('Nenhum cardápio cadastrado.');
      return ordenados;
    }

    print('Cardápios cadastrados:');
    for (final menu in ordenados) {
      print('ID: ${menu.id}');
      print('Data: ${formatarData(menu.data)}');
      print('Prato principal: ${menu.pratoPrincipal}');
      print('Acompanhamento: ${menu.acompanhamento}');
      print('Bebida: ${menu.bebida}');
      print('Sobremesa: ${menu.sobremesa}');
      print('------------------------------');
    }
    return ordenados;
  }

  /// Atualiza um cardápio. Campos deixados em branco são mantidos.
  static void atualizar() {
    if (menus.isEmpty) {
      print('Não existem cardápios para atualizar.');
      return;
    }
    listar();

    final id = int.tryParse(lerLinha('Digite o ID do cardápio a atualizar:'));
    if (id == null || buscarPorId(id) == null) {
      print('Cardápio não encontrado.');
      return;
    }

    print('Deixe em branco para manter o valor atual.');
    final textoData = lerLinha('Nova data (dd/mm/aaaa):');
    DateTime? data;
    if (textoData.isNotEmpty) {
      data = converterData(textoData);
      if (data == null) {
        print('Data inválida. Atualização cancelada.');
        return;
      }
    }
    final prato = lerLinha('Novo prato principal:');
    final acompanhamento = lerLinha('Novo acompanhamento:');
    final bebida = lerLinha('Nova bebida:');
    final sobremesa = lerLinha('Nova sobremesa:');

    try {
      atualizarMenu(
        id,
        data: data,
        pratoPrincipal: prato,
        acompanhamento: acompanhamento,
        bebida: bebida,
        sobremesa: sobremesa,
      );
      print('Cardápio atualizado com sucesso!');
    } on ArgumentError catch (e) {
      print('Atualização cancelada. ${e.message}');
    } on StateError catch (e) {
      print('Atualização cancelada. ${e.message}');
    }
  }

  /// Exclui um cardápio pelo ID.
  static void excluir() {
    if (menus.isEmpty) {
      print('Não existem cardápios para excluir.');
      return;
    }
    listar();

    final id = int.tryParse(lerLinha('Digite o ID do cardápio a excluir:'));
    if (id == null) {
      print('ID inválido.');
      return;
    }
    if (removerMenu(id)) {
      print('Cardápio excluído com sucesso.');
    } else {
      print('Cardápio não encontrado.');
    }
  }
}
