import 'menu.dart';
import 'solicitacao_de_refeicao.dart';

/// Módulo Refeitório (Grupo 8): gerencia o cardápio e as solicitações de
/// refeição.
class Refeitorio {
  /// Menu de opções do módulo refeitório, usado pelo programa principal.
  static final List<Map<String, dynamic>> menu = [
    {
      'titulo': 'Refeitório - Listar cardápios',
      'permissao': null,
      'metodo': Menu.listar,
    },
    {
      'titulo': 'Refeitório - Cadastrar cardápio',
      'permissao': 'admin',
      'metodo': Menu.cadastrar,
    },
    {
      'titulo': 'Refeitório - Atualizar cardápio',
      'permissao': 'admin',
      'metodo': Menu.atualizar,
    },
    {
      'titulo': 'Refeitório - Excluir cardápio',
      'permissao': 'admin',
      'metodo': Menu.excluir,
    },
    {
      'titulo': 'Refeitório - Solicitar refeição',
      'permissao': null,
      'metodo': SolicitacaoDeRefeicao.solicitar,
    },
    {
      'titulo': 'Refeitório - Cancelar solicitação de refeição',
      'permissao': null,
      'metodo': SolicitacaoDeRefeicao.cancelar,
    },
    {
      'titulo': 'Refeitório - Consultar status das solicitações',
      'permissao': null,
      'metodo': SolicitacaoDeRefeicao.consultarStatus,
    },
  ];
}
