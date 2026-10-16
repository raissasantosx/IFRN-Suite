import 'dart:io';
import 'package:usuarios/usuarios.dart';

/// Representa a empresa contratada/prestadora de serviços terceirizados.
class Empresa {
  final int id;
  String cnpj;
  String razaoSocial;
  String nomeFantasia;
  String areaAtuacao;
  bool isAtiva;

  static final List<Empresa> empresas = [];
  static int _proximoId = 1;

  Empresa({
    required this.id,
    required this.cnpj,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.areaAtuacao,
    this.isAtiva = true,
  });

  static Empresa criar({
    required String cnpj,
    required String razaoSocial,
    required String nomeFantasia,
    required String areaAtuacao,
    bool isAtiva = true,
  }) {
    final empresa = Empresa(
      id: _proximoId++,
      cnpj: cnpj,
      razaoSocial: razaoSocial,
      nomeFantasia: nomeFantasia,
      areaAtuacao: areaAtuacao,
      isAtiva: isAtiva,
    );
    empresas.add(empresa);
    return empresa;
  }
}

/// Representa o Servidor Terceirizado, que herda da classe base Usuario.
class ServidorTerceirizado extends Usuario {
  final int matricula;
  Empresa empresa;
  String cargoFuncao;
  String turno;

  static final List<ServidorTerceirizado> terceirizados = [];

  ServidorTerceirizado({
    required super.id,
    required super.nome,
    required super.email,
    required super.senha,
    required super.dataCadastro,
    super.permissoes,
    required this.matricula,
    required this.empresa,
    required this.cargoFuncao,
    required this.turno,
  }) {
    terceirizados.add(this);
  }
}

/// Controlador responsável pelas ações e menus de Serviços Terceirizados.
class ServicosTerceirizadosController {
  static List<Map<String, dynamic>> menu = [
    {
      'titulo': 'Serviços Terceirizados - Listar terceirizados',
      'permissao': null,
      'metodo': listar,
    },
    {
      'titulo': 'Serviços Terceirizados - Cadastrar terceirizado',
      'permissao': null,
      'metodo': cadastrar,
    },
    {
      'titulo': 'Serviços Terceirizados - Editar terceirizado',
      'permissao': null,
      'metodo': editar,
    },
    {
      'titulo': 'Serviços Terceirizados - Excluir terceirizado',
      'permissao': null,
      'metodo': excluir,
    },
    {
      'titulo': 'Serviços Terceirizados - Listar empresas',
      'permissao': null,
      'metodo': listarEmpresas,
    },
    {
      'titulo': 'Serviços Terceirizados - Cadastrar empresa',
      'permissao': null,
      'metodo': cadastrarEmpresa,
    },
  ];

  // ==================== LISTAR ====================
  static void listar([dynamic usuario]) {
    if (ServidorTerceirizado.terceirizados.isEmpty) {
      print('\nNenhum servidor terceirizado cadastrado.');
      return;
    }

    print('\n================ SERVIDORES TERCEIRIZADOS ================');
    for (final st in ServidorTerceirizado.terceirizados) {
      print('''
ID Usuário: ${st.id} | Matrícula: ${st.matricula}
Nome: ${st.nome}
E-mail: ${st.email}
Empresa: ${st.empresa.nomeFantasia} (CNPJ: ${st.empresa.cnpj})
Cargo/Função: ${st.cargoFuncao}
Turno: ${st.turno}
Permissões: ${st.permissoes.join(', ')}
Data de Cadastro: ${st.dataCadastro}
----------------------------------------------------------''');
    }
  }

  // ==================== CADASTRAR ====================
  static void cadastrar([dynamic usuario]) {
    print('\n--- Cadastrar Servidor Terceirizado ---');

    if (Empresa.empresas.isEmpty) {
      print('Aviso: É necessário ter pelo menos uma empresa cadastrada!');
      print('Deseja cadastrar uma empresa agora? (s/n):');
      final resp = stdin.readLineSync()?.trim().toLowerCase();
      if (resp == 's') {
        cadastrarEmpresa(usuario);
      }
      if (Empresa.empresas.isEmpty) {
        print('Operação cancelada. Cadastre uma empresa primeiro.');
        return;
      }
    }

    print('Digite a matrícula:');
    final entradaMatricula = stdin.readLineSync() ?? '';
    final matricula = int.tryParse(entradaMatricula.trim());
    if (matricula == null) {
      print('Matrícula inválida. Cadastro cancelado.');
      return;
    }

    final matriculaExiste = ServidorTerceirizado.terceirizados.any(
      (st) => st.matricula == matricula,
    );
    if (matriculaExiste) {
      print('Já existe um servidor terceirizado com essa matrícula.');
      return;
    }

    print('Digite o nome:');
    final nome = stdin.readLineSync()?.trim() ?? '';

    print('Digite o e-mail:');
    final email = stdin.readLineSync()?.trim() ?? '';

    print('Digite a senha:');
    final senha = stdin.readLineSync() ?? '';

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      print('Cadastro cancelado. Nome, e-mail e senha são obrigatórios.');
      return;
    }

    print('\nEscolha o ID da empresa contratante:');
    listarEmpresas();
    final entradaIdEmpresa = stdin.readLineSync() ?? '';
    final idEmpresa = int.tryParse(entradaIdEmpresa.trim());
    final empresa = Empresa.empresas.cast<Empresa?>().firstWhere(
      (e) => e?.id == idEmpresa,
      orElse: () => null,
    );

    if (empresa == null) {
      print('Empresa inválida ou não encontrada.');
      return;
    }

    print('Digite o cargo/função (ex: Limpeza, Portaria, Técnico de TI):');
    final cargoFuncao = stdin.readLineSync()?.trim() ?? 'Geral';

    print('Digite o turno (ex: Matutino, Vespertino, Noturno):');
    final turno = stdin.readLineSync()?.trim() ?? 'Integral';

    print('Digite permissões extras separadas por vírgula (ou deixe vazio):');
    final entradaPermissoes = stdin.readLineSync() ?? '';
    final permissoes = entradaPermissoes
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (!permissoes.contains('terceirizado')) {
      permissoes.add('terceirizado');
    }

    final novoTerceirizado = ServidorTerceirizado(
      id: Usuario.usuarios.length + 1,
      nome: nome,
      email: email,
      senha: senha,
      dataCadastro: DateTime.now(),
      permissoes: permissoes,
      matricula: matricula,
      empresa: empresa,
      cargoFuncao: cargoFuncao,
      turno: turno,
    );

    // Também registra na lista global de usuários do sistema base
    Usuario.usuarios.add(novoTerceirizado);

    print('\nServidor terceirizado "${novoTerceirizado.nome}" cadastrado com sucesso!');
  }

  // ==================== EDITAR ====================
  static void editar([dynamic usuario]) {
    if (ServidorTerceirizado.terceirizados.isEmpty) {
      print('\nNenhum servidor terceirizado cadastrado para editar.');
      return;
    }

    listar();

    print('\nDigite a matrícula do terceirizado que deseja editar:');
    final entrada = stdin.readLineSync() ?? '';
    final matricula = int.tryParse(entrada.trim());

    if (matricula == null) {
      print('Matrícula inválida.');
      return;
    }

    final terceirizado = ServidorTerceirizado.terceirizados.cast<ServidorTerceirizado?>().firstWhere(
      (st) => st?.matricula == matricula,
      orElse: () => null,
    );

    if (terceirizado == null) {
      print('Nenhum servidor terceirizado encontrado com essa matrícula.');
      return;
    }

    print('Deseja alterar o cargo/função atual ("${terceirizado.cargoFuncao}")? (s/n)');
    if (stdin.readLineSync()?.toLowerCase() == 's') {
      print('Novo cargo/função:');
      final novoCargo = stdin.readLineSync()?.trim();
      if (novoCargo != null && novoCargo.isNotEmpty) {
        terceirizado.cargoFuncao = novoCargo;
      }
    }

    print('Deseja alterar o turno atual ("${terceirizado.turno}")? (s/n)');
    if (stdin.readLineSync()?.toLowerCase() == 's') {
      print('Novo turno:');
      final novoTurno = stdin.readLineSync()?.trim();
      if (novoTurno != null && novoTurno.isNotEmpty) {
        terceirizado.turno = novoTurno;
      }
    }

    print('Deseja alterar a empresa? (s/n)');
    if (stdin.readLineSync()?.toLowerCase() == 's') {
      listarEmpresas();
      print('Digite o ID da nova empresa:');
      final novoIdEmp = int.tryParse(stdin.readLineSync() ?? '');
      final novaEmpresa = Empresa.empresas.cast<Empresa?>().firstWhere(
        (e) => e?.id == novoIdEmp,
        orElse: () => null,
      );
      if (novaEmpresa != null) {
        terceirizado.empresa = novaEmpresa;
      } else {
        print('Empresa não alterada (ID não encontrado).');
      }
    }

    print('\nDados do servidor terceirizado atualizados com sucesso!');
  }

  // ==================== EXCLUIR ====================
  static void excluir([dynamic usuario]) {
    if (ServidorTerceirizado.terceirizados.isEmpty) {
      print('\nNenhum servidor terceirizado para excluir.');
      return;
    }

    listar();

    print('\nDigite a matrícula do terceirizado que deseja excluir:');
    final entrada = stdin.readLineSync() ?? '';
    final matricula = int.tryParse(entrada.trim());

    if (matricula == null) {
      print('Matrícula inválida.');
      return;
    }

    final index = ServidorTerceirizado.terceirizados.indexWhere(
      (st) => st.matricula == matricula,
    );

    if (index == -1) {
      print('Servidor terceirizado não encontrado.');
      return;
    }

    final removido = ServidorTerceirizado.terceirizados.removeAt(index);
    Usuario.usuarios.removeWhere((u) => u.id == removido.id);

    print('\nServidor terceirizado "${removido.nome}" excluído com sucesso.');
  }

  // ==================== EMPRESAS ====================
  static void listarEmpresas([dynamic usuario]) {
    if (Empresa.empresas.isEmpty) {
      print('\nNenhuma empresa cadastrada.');
      return;
    }

    print('\n---------------- EMPRESAS ----------------');
    for (final emp in Empresa.empresas) {
      print('ID: ${emp.id} | Nome: ${emp.nomeFantasia} | CNPJ: ${emp.cnpj}');
      print('Razão Social: ${emp.razaoSocial}');
      print('Área de Atuação: ${emp.areaAtuacao} | Ativa: ${emp.isAtiva ? "Sim" : "Não"}');
      print('------------------------------------------');
    }
  }

  static void cadastrarEmpresa([dynamic usuario]) {
    print('\n--- Cadastrar Empresa ---');

    print('CNPJ:');
    final cnpj = stdin.readLineSync()?.trim() ?? '';

    print('Razão Social:');
    final razaoSocial = stdin.readLineSync()?.trim() ?? '';

    print('Nome Fantasia:');
    final nomeFantasia = stdin.readLineSync()?.trim() ?? '';

    print('Área de Atuação (ex: Segurança, Conservação/Limpeza, TI):');
    final areaAtuacao = stdin.readLineSync()?.trim() ?? '';

    if (cnpj.isEmpty || razaoSocial.isEmpty || nomeFantasia.isEmpty || areaAtuacao.isEmpty) {
      print('Cadastro cancelado. Todos os campos são obrigatórios.');
      return;
    }

    final novaEmpresa = Empresa.criar(
      cnpj: cnpj,
      razaoSocial: razaoSocial,
      nomeFantasia: nomeFantasia,
      areaAtuacao: areaAtuacao,
    );

    print('\nEmpresa "${novaEmpresa.nomeFantasia}" cadastrada com sucesso! (ID: ${novaEmpresa.id})');
  }
}
