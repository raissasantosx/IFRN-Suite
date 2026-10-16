
import 'package:test/test.dart';
import 'package:usuarios/usuarios.dart';

void main() {
  group('Testes do módulo de Usuários', () {
    test('Deve criar um usuário corretamente', () {
      final usuario = Usuario(
        id: 1,
        nome: 'Marcos',
        email: 'marcos@ifrn.edu.br',
        senha: 'senha123',
        dataCadastro: DateTime(2026, 10, 12),
        permissoes: ['admin'],
      );

      expect(usuario.id, 1);
      expect(usuario.nome, 'Marcos');
      expect(usuario.email, 'marcos@ifrn.edu.br');
      expect(usuario.permissoes, contains('admin'));
    });

    test('Deve iniciar com lista de permissões vazia', () {
      final usuario = Usuario(
        id: 2,
        nome: 'Maria',
        email: 'maria@ifrn.edu.br',
        senha: 'senha456',
        dataCadastro: DateTime(2026, 10, 12),
      );

      expect(usuario.permissoes, isEmpty);
    });

    test('O menu deve conter as opções de usuários', () {
      final titulos = Usuario.menu
          .map((opcao) => opcao['titulo'])
          .toList();

      expect(titulos, contains('Listar usuários'));
      expect(titulos, contains('Cadastrar usuário'));
      expect(titulos, contains('Excluir usuário'));
    });
  });
}
