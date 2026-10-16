import 'package:servicos_terceirizados/servicos_terceirizados.dart';
import 'package:test/test.dart';

void main() {
  group('Serviços Terceirizados Tests', () {
    test('Cadastro de Empresa', () {
      final empresa = Empresa.criar(
        cnpj: '12.345.678/0001-90',
        razaoSocial: 'Serviços Gerais Ltda',
        nomeFantasia: 'SG Facilities',
        areaAtuacao: 'Limpeza e Conservação',
      );

      expect(empresa.id, greaterThan(0));
      expect(empresa.nomeFantasia, equals('SG Facilities'));
      expect(empresa.isAtiva, isTrue);
      expect(Empresa.empresas.contains(empresa), isTrue);
    });

    test('Cadastro de Servidor Terceirizado herdando de Usuario', () {
      final empresa = Empresa.empresas.first;

      final terceirizado = ServidorTerceirizado(
        id: 10,
        nome: 'João da Silva',
        email: 'joao.silva@terceirizados.ifrn.edu.br',
        senha: 'senha123',
        dataCadastro: DateTime.now(),
        matricula: 20261001,
        empresa: empresa,
        cargoFuncao: 'Porteiro',
        turno: 'Matutino',
      );

      expect(terceirizado.matricula, equals(20261001));
      expect(terceirizado.empresa.nomeFantasia, equals('SG Facilities'));
      expect(terceirizado.cargoFuncao, equals('Porteiro'));
      expect(terceirizado.turno, equals('Matutino'));
      expect(ServidorTerceirizado.terceirizados.contains(terceirizado), isTrue);
    });
  });
}
