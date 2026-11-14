import 'package:flutter_test/flutter_test.dart';
import 'package:explore_mundo/destination.dart';
import 'package:explore_mundo/main.dart';

void main() {
  test('pesquisa ignora acentos, espaços e maiúsculas', () {
    expect(searchDestinations('  SUICA ').single.id, 'lago');
    expect(searchDestinations('brasil').single.id, 'praia');
    expect(searchDestinations('montanhas europa').single.id, 'montanhas');
    expect(searchDestinations('lua'), isEmpty);
    expect(searchDestinations('').length, 3);
  });
  test('formata preço em reais', () {
    expect(money(4590), 'R\$ 4.590,00');
    expect(money(0), 'R\$ 0,00');
    expect(money(1234567), 'R\$ 1.234.567,00');
  });
  test('formulários rejeitam campos inválidos', () {
    expect(requiredText(' '), isNotNull);
    expect(requiredText('Visitante'), isNull);
    expect(validEmail('invalido'), isNotNull);
    expect(validEmail('pessoa@example.com'), isNull);
  });
}
