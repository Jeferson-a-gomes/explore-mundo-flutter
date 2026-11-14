// Verificação offline executável sem pacotes, rede ou inicialização do Flutter.
import '../lib/destination.dart';

void main() {
  void check(bool condition, String name) {
    if (!condition) throw StateError(name);
    print('PASS: $name');
  }

  check(
    searchDestinations('  SUICA ').single.id == 'lago',
    'busca sem acentos',
  );
  check(
    searchDestinations('BRASIL').single.id == 'praia',
    'busca sem distinguir caixa',
  );
  check(
    searchDestinations('montanhas europa').single.id == 'montanhas',
    'busca com múltiplos termos',
  );
  check(searchDestinations('lua').isEmpty, 'busca sem resultados');
  check(searchDestinations('').length == 3, 'catálogo completo');
  check(money(4590) == 'R\$ 4.590,00', 'moeda brasileira');
  check(money(0) == 'R\$ 0,00', 'moeda zero');
  check(money(1234567) == 'R\$ 1.234.567,00', 'milhões');
  check(
    destinations.map((d) => d.id).toSet().length == destinations.length,
    'identificadores únicos',
  );
}
