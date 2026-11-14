import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:explore_mundo/main.dart';

void main() {
  testWidgets('pesquisa mostra resultados e permite limpar', (tester) async {
    await tester.pumpWidget(const ExploreMundoApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('search')), 'lua');
    await tester.pumpAndSettle();
    expect(find.text('Nenhum destino encontrado'), findsOneWidget);
    await tester.tap(find.byTooltip('Limpar pesquisa'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum destino encontrado'), findsNothing);
    await tester.enterText(find.byKey(const Key('search')), 'Suica');
    await tester.pumpAndSettle();
    expect(find.text('1 destino(s) encontrado(s)'), findsOneWidget);
  });

  testWidgets('banner abre detalhes e favorito muda de estado', (tester) async {
    await tester.pumpWidget(const ExploreMundoApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FeaturedBanner));
    await tester.pumpAndSettle();
    expect(find.text('Conheça seu destino'), findsOneWidget);
    await tester.tap(find.byTooltip('Adicionar aos favoritos'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remover dos favoritos'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FeaturedBanner));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remover dos favoritos'), findsOneWidget);
  });

  testWidgets('reserva valida, permite cancelar e registra simulação', (
    tester,
  ) async {
    await tester.pumpWidget(const ExploreMundoApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FeaturedBanner));
    await tester.pumpAndSettle();
    final button = find.widgetWithText(ElevatedButton, 'Simular reserva');
    await tester.scrollUntilVisible(button, 300);
    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar simulação'));
    await tester.pumpAndSettle();
    expect(find.text('Informe um e-mail válido.'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome'),
      'Visitante',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'pessoa@example.com',
    );
    await tester.tap(find.text('Confirmar simulação'));
    await tester.pumpAndSettle(const Duration(milliseconds: 400));
    expect(find.text('Simulação registrada'), findsOneWidget);
    await tester.tap(find.text('Entendi'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pacotes de viagem'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Suas solicitações nesta sessão'),
      500,
    );
    expect(find.textContaining('1 viajante(s)'), findsOneWidget);
  });

  testWidgets('layout em tela estreita não causa overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ExploreMundoApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(FeaturedBanner));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
