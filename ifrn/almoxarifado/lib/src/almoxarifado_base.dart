import 'dart:io';
import 'package:usuarios/usuarios.dart';

class Item {
  String nome;
  String categoria;
  int quantidade;
  Item(this.nome, this.categoria, this.quantidade);
}

class Retirada {
  String nomeItem;
  int quantidade;
  Usuario usuario;
  DateTime data;
  Retirada(this.nomeItem, this.quantidade, this.usuario, this.data);
}

/// Módulo Almoxarifado
class Almoxarifado {
  /// Menu de opções do módulo
  static List<Map<String, dynamic>> menu = [
    {'titulo': 'Almoxarifado - Listar todos os itens', 'permissao': null, 'metodo': listar,},
    {'titulo': 'Almoxarifado - Cadastrar item', 'permissao': 'admin','metodo': cadastrar,},
    {'titulo': 'Almoxarifado - Retirar item', 'permissao': null,'metodo': retirar,},
    {'titulo': 'Almoxarifado - Excluir item', 'permissao': 'admin','metodo': excluir,},
  ];

  static final List<String> nomes = [];
  static final List<String> categorias = [];
  static final List<int> quantidades = [];

  // Lista para guardar o histórico
  static final List<Retirada> historicoRetiradas = [];

  /// Lista os itens 
  static void listar() {
    if (nomes.isEmpty) {
      print('Nenhum item cadastrado');
    } else {
      print('--- Itens Cadastrados ---');
      for (int i = 0; i < nomes.length; i++) {
        print('Nome:${nomes[i]} - Categoria: ${categorias[i]} - Qtd:${quantidades[i]}');
      }
    }
  }

  // Cadastra um item 
  static void cadastrar() {
    print('Digite o nome do item:');
    String? nome = stdin.readLineSync();

    print('Digite a categoria do item:');
    String? categoria = stdin.readLineSync();

    print('Digite a quantidade inicial:');
    String? qtdInput = stdin.readLineSync();
    int? quantidade = int.tryParse(qtdInput ?? '');

    if (nome != null && nome.isNotEmpty &&
        categoria != null && categoria.isNotEmpty &&
        quantidade != null && quantidade >= 0) {
      
      var novoItem = Item(nome, categoria, quantidade);

      nomes.add(novoItem.nome);
      categorias.add(novoItem.categoria);
      quantidades.add(novoItem.quantidade);
      print('Item cadastrado');
    } else {
      print('Dados inválidos. Nenhum item foi cadastrado.');
    }
  }

  // retira um item
  static void retirar() {
    listar();
    if (nomes.isEmpty) return;

    if (Usuario.usuarios.isEmpty) {
      print('Nenhum usuário cadastrado');
      return;
    }

    print('Digite o nome do item que deseja retirar:');
    String? nomeInput = stdin.readLineSync();

    if (nomeInput != null && nomes.contains(nomeInput)) {
      int index = nomes.indexOf(nomeInput);

      print('Digite a quantidade que deseja retirar:');
      String? inputQtd = stdin.readLineSync();
      int? qtdRetirar = int.tryParse(inputQtd ?? '');

      if (qtdRetirar != null && qtdRetirar > 0) {
        if (quantidades[index] >= qtdRetirar) {

          print('\nUsuários Cadastrados:');
          for (final user in Usuario.usuarios) {
            print('ID: ${user.id} | Nome: ${user.nome}');
          }

          print('Digite o ID do usuário que está realizando a retirada:');
          String? inputUser = stdin.readLineSync();
          int? idUsuario = int.tryParse(inputUser ?? '');

          if (idUsuario != null && Usuario.usuarios.any((u) => u.id == idUsuario)) {
            Usuario usuarioEncontrado = Usuario.usuarios.firstWhere((u) => u.id == idUsuario);

            quantidades[index] -= qtdRetirar;

            var novaRetirada = Retirada(nomeInput, qtdRetirar, usuarioEncontrado, DateTime.now());
            historicoRetiradas.add(novaRetirada);

            print('Retirada foi realizada pelo usuário"${usuarioEncontrado.nome}" e restam ${quantidades[index]} unidades do item "${nomes[index]}".');
          } else {
            print('Usuário não encontrado');
          }

        } else {
          print('Quantidade insuficiente. Disponível: ${quantidades[index]}');
        }
      } else {
        print('Quantidade inválida para retirada');
      }
    } else {
      print('Item não encontrado.');
    }
  }

  /// Exclui um item
  static void excluir() {
    print('Digite o nome do item que deseja excluir:');
    String? input = stdin.readLineSync();

    if (input != null && nomes.contains(input)) {
      int index = nomes.indexOf(input);
      nomes.removeAt(index);
      categorias.removeAt(index);
      quantidades.removeAt(index);
      print('Item excluído com sucesso');
    } else {
      print('Item não encontrado');
    }
  }
}