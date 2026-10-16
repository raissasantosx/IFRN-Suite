import 'package:refeitorio/refeitorio.dart';
import 'package:refeitorio/src/utilitarios.dart';
import 'package:test/test.dart';

Menu cadastrarMenu(DateTime data) => Menu.registrar(
      data: data,
      pratoPrincipal: 'Arroz e feijão',
      acompanhamento: 'Salada',
      bebida: 'Suco de caju',
      sobremesa: 'Banana',
    );

void main() {
  final dia = DateTime(2026, 10, 20);

  setUp(() {
    Menu.menus.clear();
    SolicitacaoDeRefeicao.solicitacoes.clear();
  });

  group('Menu', () {
    test('registra um cardápio com os dados informados', () {
      final menu = cadastrarMenu(dia);

      expect(Menu.menus, contains(menu));
      expect(menu.pratoPrincipal, 'Arroz e feijão');
      expect(menu.bebida, 'Suco de caju');
      expect(Menu.buscarPorId(menu.id), same(menu));
      expect(Menu.buscarPorData(dia), same(menu));
    });

    test('não aceita campos vazios', () {
      expect(
        () => Menu.registrar(
          data: dia,
          pratoPrincipal: '  ',
          acompanhamento: 'Salada',
          bebida: 'Suco',
          sobremesa: 'Fruta',
        ),
        throwsArgumentError,
      );
      expect(Menu.menus, isEmpty);
    });

    test('não aceita dois cardápios na mesma data', () {
      cadastrarMenu(dia);
      expect(() => cadastrarMenu(dia), throwsStateError);
    });

    test('atualiza apenas os campos informados', () {
      final menu = cadastrarMenu(dia);

      final ok = Menu.atualizarMenu(menu.id, bebida: 'Água', sobremesa: '');

      expect(ok, isTrue);
      expect(menu.bebida, 'Água');
      expect(menu.sobremesa, 'Banana');
      expect(menu.pratoPrincipal, 'Arroz e feijão');
    });

    test('atualizar um cardápio inexistente retorna false', () {
      expect(Menu.atualizarMenu(999, bebida: 'Água'), isFalse);
    });

    test('remove um cardápio', () {
      final menu = cadastrarMenu(dia);

      expect(Menu.removerMenu(menu.id), isTrue);
      expect(Menu.menus, isEmpty);
      expect(Menu.removerMenu(menu.id), isFalse);
    });
  });

  group('SolicitacaoDeRefeicao', () {
    test('registra solicitação pendente', () {
      cadastrarMenu(dia);

      final s = SolicitacaoDeRefeicao.registrar(data: dia);

      expect(s.status, SolicitacaoDeRefeicao.statusPendente);
      expect(s.automatica, isFalse);
      expect(SolicitacaoDeRefeicao.buscarPorId(s.id), same(s));
    });

    test('exige cardápio cadastrado na data', () {
      expect(() => SolicitacaoDeRefeicao.registrar(data: dia), throwsStateError);
    });

    test('não permite duas solicitações ativas no mesmo dia', () {
      cadastrarMenu(dia);
      SolicitacaoDeRefeicao.registrar(data: dia);

      expect(() => SolicitacaoDeRefeicao.registrar(data: dia), throwsStateError);
    });

    test('permite solicitar de novo depois de cancelar', () {
      cadastrarMenu(dia);
      final s = SolicitacaoDeRefeicao.registrar(data: dia);

      expect(s.cancelarSolicitacao(), isTrue);
      expect(s.status, SolicitacaoDeRefeicao.statusCancelada);
      expect(s.cancelarSolicitacao(), isFalse);

      final nova = SolicitacaoDeRefeicao.registrar(data: dia, automatica: true);
      expect(nova.automatica, isTrue);
    });
  });

  group('Refeitorio', () {
    test('o menu contém as opções do módulo', () {
      final titulos = Refeitorio.menu.map((o) => o['titulo']).toList();

      expect(titulos, contains('Refeitório - Listar cardápios'));
      expect(titulos, contains('Refeitório - Solicitar refeição'));
      expect(Refeitorio.menu.every((o) => o['metodo'] is Function), isTrue);
    });

    test('cadastro e exclusão de cardápio exigem permissão admin', () {
      final exigemAdmin = Refeitorio.menu
          .where((o) => o['permissao'] == 'admin')
          .map((o) => o['titulo']);

      expect(exigemAdmin, contains('Refeitório - Cadastrar cardápio'));
      expect(exigemAdmin, contains('Refeitório - Atualizar cardápio'));
      expect(exigemAdmin, contains('Refeitório - Excluir cardápio'));
    });
  });

  group('Entradas inválidas', () {
    test('converterData aceita apenas dd/mm/aaaa existente', () {
      expect(converterData('20/10/2026'), DateTime(2026, 10, 20));
      expect(converterData('5/1/2026'), DateTime(2026, 1, 5));
      expect(converterData('João'), isNull);
      expect(converterData(''), isNull);
      expect(converterData('31/02/2026'), isNull);
      expect(converterData('20/13/2026'), isNull);
      expect(converterData('0/10/2026'), isNull);
      expect(converterData('-1/10/2026'), isNull);
      expect(converterData('20/10/26'), isNull);
      expect(converterData('2026-10-20'), isNull);
    });

    test('textoValido exige ao menos uma letra', () {
      expect(textoValido('Arroz'), isTrue);
      expect(textoValido('Suco de açaí 2'), isTrue);
      expect(textoValido('123'), isFalse);
      expect(textoValido('   '), isFalse);
      expect(textoValido(''), isFalse);
    });

    test('Menu rejeita texto sem letras', () {
      expect(
        () => Menu.registrar(
          data: dia,
          pratoPrincipal: '12345',
          acompanhamento: 'Salada',
          bebida: 'Suco',
          sobremesa: 'Fruta',
        ),
        throwsArgumentError,
      );
      expect(Menu.menus, isEmpty);
    });

    test('atualizar com texto sem letras não altera nada', () {
      final menu = cadastrarMenu(dia);

      expect(
        () => Menu.atualizarMenu(menu.id, pratoPrincipal: 'Peixe', bebida: '9'),
        throwsArgumentError,
      );
      expect(menu.pratoPrincipal, 'Arroz e feijão');
    });

    test('IDs negativos ou inexistentes não são encontrados', () {
      cadastrarMenu(dia);

      expect(Menu.buscarPorId(-1), isNull);
      expect(Menu.buscarPorId(0), isNull);
      expect(Menu.buscarPorId(99), isNull);
      expect(Menu.removerMenu(-1), isFalse);
      expect(SolicitacaoDeRefeicao.buscarPorId(-1), isNull);
      expect(SolicitacaoDeRefeicao.buscarPorId(99), isNull);
    });
  });
}
