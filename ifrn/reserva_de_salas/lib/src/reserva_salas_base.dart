
import 'dart:io';

// CLASSE SALA
class Sala {
  int id;
  String numero;
  int capacidade;

  Sala(this.id, this.numero, this.capacidade);

  static List<Sala> salas = [];

  static void cadastrar() {
    print('Digite o numero da sala:');
    String numero = stdin.readLineSync()!;

    print('Digite a capacidade da sala:');
    int capacidade = int.parse(stdin.readLineSync()!);

    Sala sala = Sala(salas.length + 1, numero, capacidade);

    salas.add(sala);

    print('Sala cadastrada!');
  }

  static void listar() {
    for (Sala sala in salas) {
      print('ID: ${sala.id}');
      print('Numero: ${sala.numero}');
      print('Capacidade: ${sala.capacidade}');
    }
  }
}

// CLASSE RESERVA
class Reserva {
  int id;
  String data;
  String horario;
  Sala sala;
  String usuario;

  Reserva(
    this.id,
    this.data,
    this.horario,
    this.sala,
    this.usuario,
  );

  static List<Reserva> reservas = [];

  static void cadastrar() {
    if (Sala.salas.isEmpty) {
      print('Cadastre uma sala primeiro!');
      return;
    }

    Sala.listar();

    print('Digite o ID da sala:');
    int idSala = int.parse(stdin.readLineSync()!);

    Sala sala = Sala.salas.firstWhere(
      (s) => s.id == idSala,
    );

    print('Digite a data da reserva:');
    String data = stdin.readLineSync()!;

    print('Digite o horario da reserva:');
    String horario = stdin.readLineSync()!;

    print('Digite o nome do usuario:');
    String usuario = stdin.readLineSync()!;

    Reserva reserva = Reserva(
      reservas.length + 1,
      data,
      horario,
      sala,
      usuario,
    );

    reservas.add(reserva);

    print('Reserva realizada!');
  }

  static void listar() {
    for (Reserva reserva in reservas) {
      print('Reserva: ${reserva.id}');
      print('Data: ${reserva.data}');
      print('Horario: ${reserva.horario}');
      print('Sala: ${reserva.sala.numero}');
      print('Usuario: ${reserva.usuario}');
    }
  }
}
