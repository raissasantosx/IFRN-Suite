import 'package:almoxarifado/almoxarifado.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    Almoxarifado.itens.clear();
    Almoxarifado.proximoId = 1;
    Retiradas.registros.clear();
    // O ID da retirada é sequencial durante a execução. Os testes não dependem
    // do valor absoluto, apenas do registro e da regra de estoque.
  });

  group('Permissões de retirada', () {
    test('permite professor e técnico-administrativo', () {
      expect(Retiradas.temPermissao('professor'), isTrue);
      expect(Retiradas.temPermissao('tecnico_administrativo'), isTrue);
      expect(Retiradas.temPermissao('técnico-administrativo'), isTrue);
    });

    test('nega aluno e perfil desconhecido', () {
      expect(Retiradas.temPermissao('aluno'), isFalse);
      expect(Retiradas.temPermissao('admin'), isFalse);
    });
  });

  group('Registro de retirada', () {
    late Item item;

    setUp(() {
      item = Item(
        id: 1,
        nome: 'Papel A4',
        categoria: 'Material de escritório',
        quantidadeDisponivel: 10,
      );
      Almoxarifado.itens.add(item);
    });

    test('registra retirada e reduz o estoque', () {
      final retirada = Retiradas.registrar(
        item: item,
        quantidade: 3,
        solicitante: 'Maria',
        perfil: 'professor',
      );

      expect(retirada.quantidade, 3);
      expect(retirada.solicitante, 'Maria');
      expect(item.quantidadeDisponivel, 7);
      expect(Retiradas.registros, hasLength(1));
    });

    test('não permite retirada maior que o estoque', () {
      expect(
        () => Retiradas.registrar(
          item: item,
          quantidade: 11,
          solicitante: 'Maria',
          perfil: 'professor',
        ),
        throwsA(isA<RetiradaInvalidaError>()),
      );
      expect(item.quantidadeDisponivel, 10);
      expect(Retiradas.registros, isEmpty);
    });

    test('não permite quantidade zero ou negativa', () {
      expect(
        () => Retiradas.registrar(
          item: item,
          quantidade: 0,
          solicitante: 'Maria',
          perfil: 'professor',
        ),
        throwsA(isA<RetiradaInvalidaError>()),
      );
      expect(item.quantidadeDisponivel, 10);
    });

    test('bloqueia perfil sem permissão sem alterar o estoque', () {
      expect(
        () => Retiradas.registrar(
          item: item,
          quantidade: 1,
          solicitante: 'Aluno',
          perfil: 'aluno',
        ),
        throwsA(isA<UnauthorizedError>()),
      );
      expect(item.quantidadeDisponivel, 10);
      expect(Retiradas.registros, isEmpty);
    });
  });
}
