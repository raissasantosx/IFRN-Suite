import 'dart:io';
import 'package:servicos_terceirizados/servicos_terceirizados.dart';

void main() {
  print('=== MÓDULO GRUPO 5: SERVIÇOS TERCEIRIZADOS (IFRN) ===');

  while (true) {
    print('\nSelecione uma opção:');
    for (var i = 0; i < ServicosTerceirizadosController.menu.length; i++) {
      final item = ServicosTerceirizadosController.menu[i];
      print('${i + 1}. ${item['titulo']}');
    }
    print('0. Sair');

    stdout.write('\nOpção: ');
    final entrada = stdin.readLineSync()?.trim() ?? '';
    if (entrada == '0') {
      print('Saindo do módulo...');
      break;
    }

    final opcao = int.tryParse(entrada);
    if (opcao == null || opcao < 1 || opcao > ServicosTerceirizadosController.menu.length) {
      print('Opção inválida! Tente novamente.');
      continue;
    }

    final itemSelecionado = ServicosTerceirizadosController.menu[opcao - 1];
    final Function metodo = itemSelecionado['metodo'];
    metodo();
  }
}
