import 'dart:io';
import 'aula_model.dart';

class Disciplina {
  final int id;
  String nome;
  String professor;
  final List<String> alunosMatriculados;
  final List<String> aulas;
  int cargaHoraria;
  String local;

  static final List<Disciplina> disciplinas = [];
  static int proximoId = 1;

  Disciplina({
    required this.id,
    required this.nome,
    required this.professor,
    List<String>? alunosMatriculados,
    List<String>? aulas,
    required this.cargaHoraria,
    required this.local,
  })  : alunosMatriculados = alunosMatriculados ?? [],
        aulas = aulas ?? [];

  static Disciplina? buscarPorId(int id) {
    for (final disciplina in disciplinas) {
      if (disciplina.id == id) {
        return disciplina;
      }
    }
    return null;
  }

  static void listar() {
    if (disciplinas.isEmpty) {
      print('Nenhuma disciplina cadastrada.');
      return;
    }

    print('Disciplinas cadastradas:');
    for (final disciplina in disciplinas) {
      print('ID: ${disciplina.id}');
      print('Nome: ${disciplina.nome}');
      print('Professor: ${disciplina.professor}');
      print('------------------------------');
    }
  }

  static void consultar() {
    if (disciplinas.isEmpty) {
      print('Nenhuma disciplina cadastrada.');
      return;
    }

    listar();
    print('Digite o ID da disciplina:');
    final id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null) {
      print('ID inválido.');
      return;
    }

    final disciplina = buscarPorId(id);
    if (disciplina == null) {
      print('Disciplina não encontrada.');
      return;
    }

    print('ID: ${disciplina.id}');
    print('Nome: ${disciplina.nome}');
    print('Professor: ${disciplina.professor}');
    print('Carga horária: ${disciplina.cargaHoraria}');
    print('Local: ${disciplina.local}');
    print('Alunos: ${disciplina.alunosMatriculados.join(', ')}');

    print('Aulas cadastradas nesta disciplina:');
    bool temAula = false;
    for (final aula in Aula.aulasArray) {
      if (aula.disciplina.id == disciplina.id) {
        print('ID: ${aula.id} - Data: ${aula.data}');
        temAula = true;
      }
    }
    if (!temAula) {
      print('Nenhuma aula cadastrada.');
    }
  }

  static void cadastrar() {
    print('Digite o nome da disciplina:');
    final nome = stdin.readLineSync()?.trim() ?? '';

    print('Digite o professor:');
    final professor = stdin.readLineSync()?.trim() ?? '';

    print('Digite a carga horária:');
    final cargaHoraria = int.tryParse(stdin.readLineSync() ?? '');

    print('Digite o local:');
    final local = stdin.readLineSync()?.trim() ?? '';

    if (nome.isEmpty || professor.isEmpty || local.isEmpty ||
        cargaHoraria == null || cargaHoraria <= 0) {
      print('Dados inválidos. Cadastro cancelado.');
      return;
    }

    print('Digite os alunos separados por vírgula (ENTER para nenhum):');
    final entrada = stdin.readLineSync() ?? '';
    final alunos = <String>[];

    for (final parte in entrada.split(',')) {
      final aluno = parte.trim();
      if (aluno.isNotEmpty && !alunos.contains(aluno)) {
        alunos.add(aluno);
      }
    }

    final disciplina = Disciplina(
      id: proximoId++,
      nome: nome,
      professor: professor,
      cargaHoraria: cargaHoraria,
      local: local,
      alunosMatriculados: alunos,
    );

    disciplinas.add(disciplina);
    print('Disciplina cadastrada com ID ${disciplina.id}.');
  }

  static void editar() {
    if (disciplinas.isEmpty) {
      print('Nenhuma disciplina cadastrada.');
      return;
    }

    listar();
    print('Digite o ID da disciplina que deseja editar:');
    final id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null) {
      print('ID inválido.');
      return;
    }

    final disciplina = buscarPorId(id);
    if (disciplina == null) {
      print('Disciplina não encontrada.');
      return;
    }

    print('Novo nome (ENTER para manter):');
    final nome = stdin.readLineSync()?.trim() ?? '';

    print('Novo professor (ENTER para manter):');
    final professor = stdin.readLineSync()?.trim() ?? '';

    print('Nova carga horária (ENTER para manter):');
    final entradaCarga = stdin.readLineSync()?.trim() ?? '';

    print('Novo local (ENTER para manter):');
    final local = stdin.readLineSync()?.trim() ?? '';

    print('Novos alunos (ENTER para manter, - para limpar):');
    final entradaAlunos = stdin.readLineSync()?.trim() ?? '';

    if (entradaCarga.isNotEmpty) {
      final carga = int.tryParse(entradaCarga);
      if (carga == null || carga <= 0) {
        print('Carga horária inválida. Edição cancelada.');
        return;
      }
      disciplina.cargaHoraria = carga;
    }

    if (nome.isNotEmpty) {
      disciplina.nome = nome;
    }
    if (professor.isNotEmpty) {
      disciplina.professor = professor;
    }
    if (local.isNotEmpty) {
      disciplina.local = local;
    }

    if (entradaAlunos.isNotEmpty) {
      disciplina.alunosMatriculados.clear();
      if (entradaAlunos != '-') {
        for (final parte in entradaAlunos.split(',')) {
          final aluno = parte.trim();
          if (aluno.isNotEmpty &&
              !disciplina.alunosMatriculados.contains(aluno)) {
            disciplina.alunosMatriculados.add(aluno);
          }
        }
      }
    }

    print('Disciplina editada com sucesso.');
  }

  static void excluir() {
    if (disciplinas.isEmpty) {
      print('Nenhuma disciplina cadastrada.');
      return;
    }

    listar();
    print('Digite o ID da disciplina que deseja excluir:');
    final id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null) {
      print('ID inválido.');
      return;
    }

    final disciplina = buscarPorId(id);
    if (disciplina == null) {
      print('Disciplina não encontrada.');
      return;
    }

    // Verifica a lista original da classe Aula sem modificar o módulo do colega.
    for (final aula in Aula.aulasArray) {
      if (aula.disciplina.id == disciplina.id) {
        print('Exclua as aulas dessa disciplina primeiro.');
        return;
      }
    }

    disciplinas.remove(disciplina);
    print('Disciplina excluída com sucesso.');
  }
}
