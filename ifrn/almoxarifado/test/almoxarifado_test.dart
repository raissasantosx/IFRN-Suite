import 'package:almoxarifado/almoxarifado.dart';
import 'package:test/test.dart';

void main() {
  group('Testes do Almoxarifado', () {
    test('Verifica se a lista de itens inicia vazia', () {
      expect(Almoxarifado.nomes.isEmpty, isTrue);
    });
  });
}