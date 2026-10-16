
import 'package:test/test.dart';
import 'package:reserva_salas/reserva_salas.dart';

void main() {
  group('Testes do módulo Reserva de Salas', () {
    test('Deve cadastrar uma sala', () {
      Sala.salas.clear();

      Sala sala = Sala(1, '101', 30);
      Sala.salas.add(sala);

      expect(Sala.salas.length, 1);
      expect(Sala.salas[0].numero, '101');
      expect(Sala.salas[0].capacidade, 30);
    });

    test('Deve criar uma reserva corretamente', () {
      Sala.salas.clear();
      Reserva.reservas.clear();

      Sala sala = Sala(1, '102', 40);

      Reserva reserva = Reserva(
        1,
        '15/10/2026',
        '14:00',
        sala,
        'Nome_usuario',
      );

      Reserva.reservas.add(reserva);

      expect(Reserva.reservas.length, 1);
      expect(reserva.data, '15/10/2026');
      expect(reserva.horario, '14:00');
      expect(reserva.sala.numero, '102');
      expect(reserva.usuario, 'Nome_usuario');
    });
  });
}
