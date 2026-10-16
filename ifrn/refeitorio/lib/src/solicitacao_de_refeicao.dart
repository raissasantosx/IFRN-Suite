import 'menu.dart';
import 'utilitarios.dart';

/// Solicitação de refeição (classe SolicitacaoDeRefeicao do diagrama).
class SolicitacaoDeRefeicao {
  /// Status de uma solicitação recém-criada.
  static const String statusPendente = 'PENDENTE';

  /// Status de uma solicitação cancelada pelo usuário.
  static const String statusCancelada = 'CANCELADA';

  /// Identificador único da solicitação.
  final int id;

  /// Dia da refeição solicitada.
  DateTime data;

  /// Situação atual: [statusPendente] ou [statusCancelada].
  String status;

  /// Indica se a solicitação é automática (recorrente).
  bool automatica;

  SolicitacaoDeRefeicao({
    required this.id,
    required this.data,
    this.status = statusPendente,
    this.automatica = false,
  });

  /// Solicitações registradas durante a execução do programa.
  static final List<SolicitacaoDeRefeicao> solicitacoes = [];

  /// Próximo identificador disponível.
  static int _proximoId = 1;

  /// Indica se a solicitação ainda não foi cancelada.
  bool get ativa => status != statusCancelada;

  @override
  String toString() =>
      'ID: $id | ${formatarData(data)} | $status | '
      '${automatica ? 'automática' : 'manual'}';

  // ---------------------------------------------------------------------
  // Regras de negócio (sem leitura de teclado, para poderem ser testadas)
  // ---------------------------------------------------------------------

  /// Registra uma solicitação para [data]. Lança [StateError] se não houver
  /// cardápio na data ou se já existir solicitação ativa para o dia.
  static SolicitacaoDeRefeicao registrar({
    required DateTime data,
    bool automatica = false,
  }) {
    if (Menu.buscarPorData(data) == null) {
      throw StateError('Não há cardápio cadastrado para essa data.');
    }
    final duplicada = solicitacoes.any((s) => s.ativa && mesmoDia(s.data, data));
    if (duplicada) {
      throw StateError('Já existe uma solicitação ativa para essa data.');
    }
    final solicitacao = SolicitacaoDeRefeicao(
      id: _proximoId++,
      data: DateTime(data.year, data.month, data.day),
      automatica: automatica,
    );
    solicitacoes.add(solicitacao);
    return solicitacao;
  }

  /// Busca uma solicitação pelo ID. Retorna `null` se não existir.
  static SolicitacaoDeRefeicao? buscarPorId(int id) {
    for (final s in solicitacoes) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Cancela esta solicitação. Retorna `false` se já estava cancelada.
  bool cancelarSolicitacao() {
    if (!ativa) return false;
    status = statusCancelada;
    return true;
  }

  // ---------------------------------------------------------------------
  // Operações interativas (usadas no menu do programa principal)
  // ---------------------------------------------------------------------

  /// Solicita uma refeição 
  static void solicitar() {
    if (Menu.menus.isEmpty) {
      print('Nenhum cardápio cadastrado. Não é possível solicitar refeição.');
      return;
    }
    Menu.listar();

    final data = converterData(
      lerLinha('Digite a data da refeição (dd/mm/aaaa):'),
    );
    if (data == null) {
      print('Data inválida. Solicitação cancelada.');
      return;
    }
    final resposta = lerLinha('Solicitação automática (recorrente)? (s/n):')
        .toLowerCase();
    if (resposta != 's' && resposta != 'n') {
      print('Resposta inválida. Digite "s" ou "n". Solicitação cancelada.');
      return;
    }
    final automatica = resposta == 's';

    try {
      registrar(data: data, automatica: automatica);
      print('Refeição solicitada com sucesso!');
    } on StateError catch (e) {
      print('Solicitação cancelada. ${e.message}');
    }
  }

  /// Cancela uma solicitação ativa.
  static void cancelar() {
    final ativas = solicitacoes.where((s) => s.ativa).toList();
    if (ativas.isEmpty) {
      print('Não há solicitações ativas.');
      return;
    }
    print('Solicitações ativas:');
    for (final s in ativas) {
      print('- $s');
    }

    final id = int.tryParse(lerLinha('Digite o ID da solicitação a cancelar:'));
    final solicitacao = id == null ? null : buscarPorId(id);
    if (solicitacao == null || !solicitacao.ativa) {
      print('Solicitação não encontrada.');
      return;
    }
    solicitacao.cancelarSolicitacao();
    print('Solicitação cancelada com sucesso.');
  }

  /// Exibe o status das solicitações registradas.
  static void consultarStatus() {
    if (solicitacoes.isEmpty) {
      print('Nenhuma solicitação registrada.');
      return;
    }
    print('Solicitações:');
    for (final s in solicitacoes) {
      print('- $s');
    }
  }
}
