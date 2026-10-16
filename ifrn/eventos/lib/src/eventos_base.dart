import 'dart:io';
import 'package:usuarios/usuarios.dart';

class Participante {
  String nome;
  String cpf;
  Participante(this.nome, this.cpf);
}

class MembroEquipe {
  String funcao;
  Usuario usuario;
  MembroEquipe(this.funcao, this.usuario);
}

class Cronograma {
  DateTime dataInicio;
  DateTime dataFim;
  Cronograma(this.dataInicio, this.dataFim);
}

class Evento {
  String nome;
  String tema;
  String local;
  double verbaDestinada;
  List<MembroEquipe> equipe;
  List<Participante> participantes;
  Cronograma cronograma;
  Evento(this.nome, this.tema, this.local, this.verbaDestinada, this.equipe, this.participantes, this.cronograma);
}

class Eventos {
  /// Menu de opções do módulo exemplo.
  /// TODO: Adapte ao seu módulo, mas mantenha o nome da propriedade como `menu` para que o código do binário funcione corretamente.
  static List<Map<String, dynamic>> menu = [
    { 'titulo': 'Eventos - Listar todas os eventos cadastrados', 'permissao': null, 'metodo': listar },
    { 'titulo': 'Eventos - Listar participantes de um evento', 'permissao': null, 'metodo': listarParticipantes },
    { 'titulo': 'Eventos - Listar membros da equipe de um evento', 'permissao': null, 'metodo': listarMembros },
    { 'titulo': 'Eventos - Cadastrar evento', 'permissao': 'admin', 'metodo': cadastrar },
    { 'titulo': 'Eventos - Editar evento', 'permissao': 'admin', 'metodo': editar },
    { 'titulo': 'Eventos - Adicionar participante ao evento', 'permissao': 'admin', 'metodo': adicionarParticipante},
    { 'titulo': 'Eventos - Adicionar membro da equipe ao evento', 'permissao': 'admin', 'metodo': adicionarMembroEquipe},
    { 'titulo': 'Eventos - Excluir evento', 'permissao': 'admin', 'metodo': excluir },
    
    
  ];

  static final List<Evento> eventos = [];

  static Tipo pedirInput<Tipo>(String mensagem, Tipo? Function(String) parser) {
    Tipo? valor;
    do {
      print(mensagem);
      String input = stdin.readLineSync() ?? '';
      valor = parser(input);
      if (valor == null) {
        print("'$input' não é um valor válido.\n");
      }
    } while (valor == null);
    
    return valor;
  }

  static void listar() {
    if (eventos.isEmpty) {
      print('Nenhum evento cadastrado.');
    } else {
      print('Eventos cadastrados:');
      for (int i=0; i<eventos.length; i++) {
        var e = eventos[i];
        print('[$i] ${e.nome}');
        print('- Tema: ${e.tema}');
        print('- Local: ${e.local}');
        print('- Verba: R\$ ${e.verbaDestinada.toStringAsFixed(2)}');
        print('- Início: ${e.cronograma.dataInicio.toString().split('.')[0]}');
        print('- Fim: ${e.cronograma.dataFim.toString().split('.')[0]}');
        print('- Total de Participantes: ${e.participantes.length}');
        print('- Membros da Equipe: ${e.equipe.length}');
        print('----------------------------------');
      }
    }
  }

  static void listarParticipantes() {
    if (eventos.isEmpty) {
      print('Nenhum evento cadastrado.');
      return;
    }

    print('Eventos Cadastrados:');
    for (int i = 0; i < eventos.length; i++) {
      print('[$i] ${eventos[i].nome}');
    }

    int index = pedirInput<int>('Digite o número do evento para ver os participantes:', (input) {
      int? val = int.tryParse(input);
      if (val != null && val >= 0 && val < eventos.length) {
        return val;
      }
      return null;
    });

    var evento = eventos[index];
    if (evento.participantes.isEmpty) {
      print('Nenhum participante cadastrado no evento "${evento.nome}".');
    } else {
      print('Participantes do evento "${evento.nome}":');
      for (int i = 0; i < evento.participantes.length; i++) {
        var p = evento.participantes[i];
        print('[$i] Nome: ${p.nome} | CPF: ${p.cpf}');
      }
    }
  }


  static void listarMembros() {
    if (eventos.isEmpty) {
      print('Nenhum evento cadastrado.');
      return;
    }

    print('Eventos Cadastrados:');
    for (int i = 0; i < eventos.length; i++) {
      print('[$i] ${eventos[i].nome}');
    }

    int index = pedirInput<int>('Digite o número do evento para ver a equipe:', (input) {
      int? val = int.tryParse(input);
      if (val != null && val >= 0 && val < eventos.length) {
        return val;
      }
      return null;
    });

    var evento = eventos[index];
    if (evento.equipe.isEmpty) {
      print('Nenhum membro na equipe do evento "${evento.nome}".');
    } else {
      print('Membros da equipe do evento "${evento.nome}":');
      for (int i = 0; i < evento.equipe.length; i++) {
        var m = evento.equipe[i];
        print('[$i] Função: ${m.funcao} | Nome: ${m.usuario.nome}');
      }
    }
  }

  static void cadastrar() {
    print('Digite o nome do evento: ');
    String? nome = stdin.readLineSync();
    print('Digite o tema do evento: ');
    String? tema = stdin.readLineSync();
    print('Digite o local do evento: ');
    String? local = stdin.readLineSync();
    double? verbaDestinada = pedirInput('Digite a verba destinada: ', double.tryParse);
    DateTime? cronogramaDataInicio = pedirInput('Digite a data e hora de ínicio do evento (): ', DateTime.tryParse);
    DateTime? cronogramaDataFim = pedirInput('Digite a data e hora de fim do evento: ', DateTime.tryParse);

    if (nome != null && nome.isNotEmpty && tema != null && tema.isNotEmpty && local != null && local.isNotEmpty && verbaDestinada != null && cronogramaDataInicio != null && cronogramaDataFim != null) {
      var cronograma = Cronograma(cronogramaDataInicio, cronogramaDataFim);
      var evento = Evento(nome, tema, local, verbaDestinada, [], [], cronograma);
      eventos.add(evento);
      print('Evento cadastrado.');
    } else {
      print('Nenhum evento foi cadastrado.');
    }
  }

static void editar() {
    if (eventos.isEmpty) {
      print('Nenhum evento cadastrado para editar.');
      return;
    }

    print('Eventos Cadastrados:');
    for (int i = 0; i < eventos.length; i++) {
      print('[$i] ${eventos[i].nome}');
    }

    int index = pedirInput<int>('Digite o número do evento que deseja editar:', (input) {
      int? val = int.tryParse(input);
      if (val != null && val >= 0 && val < eventos.length) {
        return val;
      }
      return null;
    });

    var e = eventos[index];

    print('Nome atual [${e.nome}]:');
    String? novoNome = stdin.readLineSync();
    if (novoNome != null && novoNome.trim().isNotEmpty) e.nome = novoNome.trim();

    print('Tema atual [${e.tema}]:');
    String? novoTema = stdin.readLineSync();
    if (novoTema != null && novoTema.trim().isNotEmpty) e.tema = novoTema.trim();

    print('Local atual [${e.local}]:');
    String? novoLocal = stdin.readLineSync();
    if (novoLocal != null && novoLocal.trim().isNotEmpty) e.local = novoLocal.trim();

    print('Verba atual [${e.verbaDestinada}]:');
    String inputVerba = stdin.readLineSync() ?? '';
    if (inputVerba.trim().isNotEmpty) {
      double? novaVerba = double.tryParse(inputVerba);
      if (novaVerba != null) e.verbaDestinada = novaVerba;
    }

    print('Data de início atual [${e.cronograma.dataInicio}]:');
    String inputInicio = stdin.readLineSync() ?? '';
    if (inputInicio.trim().isNotEmpty) {
      DateTime? novaData = DateTime.tryParse(inputInicio);
      if (novaData != null) e.cronograma.dataInicio = novaData;
    }

    print('Data de fim atual [${e.cronograma.dataFim}]:');
    String inputFim = stdin.readLineSync() ?? '';
    if (inputFim.trim().isNotEmpty) {
      DateTime? novaData = DateTime.tryParse(inputFim);
      if (novaData != null) e.cronograma.dataFim = novaData;
    }

    print('Evento atualizado com sucesso!');
  }

  static void adicionarMembroEquipe(){
    if (eventos.isEmpty) {
      print('Nenhum evento cadastrado.');
      return;
    }

    if (Usuario.usuarios.isEmpty) {
      print('Nenhum usuário cadastrado no sistema. Cadastre um usuário no módulo de Usuários antes.');
      return;
    }

    print('Eventos Cadastrados');
    for (int i = 0; i<eventos.length; i++){
      print('[$i] ${eventos[i].nome}');
    }

    int index = pedirInput<int>('Digite o número do evento:', (input) {
      int? val = int.tryParse(input);
       if (val !=null && val>= 0 && val < eventos.length){
       return val;
    }
    return null;
  });

  print('Usuários Cadastrados:');
    for (final user in Usuario.usuarios) {
      print('ID: ${user.id} | Nome: ${user.nome} | E-mail: ${user.email}');
    }

    int idUsuario = pedirInput<int>('Digite o Id do usuário que deseja adicionar à equipe:', (input) {
      int? id = int.tryParse(input);
      if (id != null && Usuario.usuarios.any((user) => user.id == id)) {
        return id;
      }
      return null;
    });

    Usuario usuarioEncontrado = Usuario.usuarios.firstWhere((user) => user.id == idUsuario);
  
    print('Digite a função do membro:');
    String funcao = stdin.readLineSync() ?? '';

    if (funcao.trim().isNotEmpty) {
      var membro = MembroEquipe(funcao.trim(), usuarioEncontrado);
      eventos[index].equipe.add(membro);
      print('Membro "${usuarioEncontrado.nome}" ($funcao) adicionado à equipe do evento "${eventos[index].nome}".');
    } else {
      print('A função não pode ser vazia.');
    }
  }

  static void adicionarParticipante(){
    if (eventos.isEmpty) {
      print('Nenhum evento cadastrado.');
      return;
    }

    print('Eventos Cadastrados');
    for (int i = 0; i<eventos.length; i++){
      print('[$i] ${eventos[i].nome}');
    }

    int index = pedirInput<int>('Digite o número do evento:', (input) {
      int? val = int.tryParse(input);
      if (val !=null && val>= 0 && val < eventos.length){
      return val;
    }
    return null;
  });

  print('Digite o nome do participante:');
  String nome = stdin.readLineSync() ?? '';

  print('Digite o CPF do participante:');
  String cpf = stdin.readLineSync() ?? '';

  if (nome.trim().isNotEmpty && cpf.trim().isNotEmpty) {
    var participante = Participante(nome.trim(), cpf.trim());
    eventos[index].participantes.add(participante);
    print('Participante "${nome}" adicionado ao evento');
  } else {
    print('Nome e CPF não podem ser vazios.');
  }
}
  static void excluir() {
    if (eventos.isEmpty) {
      print('Nenhum evento cadastrado.');
    } else {
      print('Eventos cadastrados:');
      for (int i=0; i<eventos.length; i++) {
        var e = eventos[i];
        print('[$i] ${e.nome}'); }
      
      print('Digite a informação que deseja excluir:');
      String? input = stdin.readLineSync() ?? '';
      int? index = int.tryParse(input);
      if (index != null && index >= 0 && index < eventos.length) {
        eventos.removeAt(index);
        print('Evento excluído com sucesso.');
      } else {
        print('Evento não encontrado.');
      }
    }
  }
}
