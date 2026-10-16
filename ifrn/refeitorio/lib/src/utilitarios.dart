import 'dart:io';

/// Funções auxiliares internas do módulo (não exportadas pelo pacote, para
/// não colidir com nomes de outros módulos).

/// Exibe [mensagem] e lê uma linha do teclado.
///
/// Por padrão remove os espaços das pontas ([aparar]). Se a entrada terminar
/// (fim de arquivo), retorna texto vazio em vez de lançar erro.
String lerLinha(String mensagem, {bool aparar = true}) {
  print(mensagem);
  final linha = stdin.readLineSync() ?? '';
  return aparar ? linha.trim() : linha;
}

/// Formata uma data como dd/mm/aaaa.
String formatarData(DateTime data) {
  final d = data.day.toString().padLeft(2, '0');
  final m = data.month.toString().padLeft(2, '0');
  return '$d/$m/${data.year}';
}

final RegExp _formatoData = RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$');

/// Converte um texto dd/mm/aaaa em [DateTime]. Retorna `null` se o formato
/// for inválido ou se a data não existir (como 31/02/2026 ou abc).
DateTime? converterData(String texto) {
  final entrada = texto.trim();
  if (!_formatoData.hasMatch(entrada)) return null;
  final partes = entrada.split('/');
  final dia = int.parse(partes[0]);
  final mes = int.parse(partes[1]);
  final ano = int.parse(partes[2]);
  final data = DateTime(ano, mes, dia);
  if (data.day != dia || data.month != mes || data.year != ano) return null;
  return data;
}

/// Indica se duas datas caem no mesmo dia (ignora a hora).
bool mesmoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

final RegExp _letra = RegExp(r'\p{L}', unicode: true);

/// Indica se [texto] é um texto descritivo válido: não vazio e com pelo menos
/// uma letra (rejeita entradas como "123" ou "!!!").
bool textoValido(String texto) => _letra.hasMatch(texto);
