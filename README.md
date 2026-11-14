# Explore Mundo · Flutter

Trabalho prático individual da disciplina **DGT2812 - Desenvolvimento de Aplicativos Móveis com Flutter**, Estácio.

**Autor:** Jeferson Augusto Gomes · **Data:** 14/11/2026

Protótipo de agência de viagens baseado no roteiro [Posso criar um App de outra forma!](https://sway.cloud.microsoft/4hFJo0qpdyvzSSFk).

## Funcionalidades

- Banner interativo abre os detalhes de um destino.
- Navegação superior: Destinos, Pacotes de viagem, Contato e Sobre nós.
- Pesquisa por palavras, sem distinção de maiúsculas e acentos; estado sem resultados e botão limpar.
- Catálogo com fotos locais, localização, preço, duração e avaliações fictícias.
- Detalhes com imagem, seção de título, estrela, botões e descrição.
- Favoritos e comentários durante a sessão.
- Reserva demonstrativa com nome, e-mail, número de viajantes e total; validação dos campos.
- Lista de solicitações na seção Pacotes de viagem.
- Formulário de contato com validação e confirmação demonstrativa.
- Cópia do resumo do destino para a área de transferência.
- ListView para rolagem e largura máxima para telas amplas.

**Não há backend, pagamento, reserva real, envio de e-mail ou persistência após fechar/recarregar.** Não use dados pessoais reais nos formulários. Preços e avaliações são exemplos acadêmicos. As imagens são ilustrativas.

## Executar no Chrome

Instale o Flutter SDK 3.50 ou superior, com Dart >= 3.13, Git e Chrome. Depois:

```sh
flutter doctor
flutter pub get
flutter run -d chrome
```

Os arquivos de plataforma web estão incluídos. O Flutter compilará o aplicativo e servirá as imagens locais, sem depender de fotos remotas durante o uso.

## Executar no Android

A estrutura nativa Android está incluída. Instale Android Studio e Android SDK, inicie um emulador ou conecte um aparelho com depuração USB:

```sh
flutter pub get
flutter devices
flutter run -d ID_DO_DISPOSITIVO
```

O Gradle Wrapper e `pubspec.lock` estão versionados. O arquivo `android/local.properties` é específico de cada máquina e não deve ser enviado ao Git.

## Verificações

```sh
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze
flutter test
flutter build web --release
```

Verificação independente e offline dos dados do catálogo:

```sh
dart tool/check_domain.dart
```

**Validação confirmada no GitHub Actions em 14/11/2026:** formatação aprovada, `flutter analyze` sem problemas, **7 testes aprovados** (3 de domínio e 4 de widgets) e builds **web release e APK Android debug** concluídos. A verificação independente do domínio também passou em seus 9 casos.

A suíte exercita pesquisa, favoritos, validação e cancelamento de reserva, registro de solicitação e layout de 320 px. Os artefatos `explore-mundo-android` e `explore-mundo-web` estão na aba **Actions**. Não foi realizado teste em aparelho físico nem inspeção visual interativa da interface compilada.

Execução de referência: https://github.com/Jeferson-a-gomes/explore-mundo-flutter/actions/runs/43628180929

## Estrutura

```text
lib/main.dart              Aplicativo, telas, componentes e formulários
lib/destination.dart       Modelo, catálogo, pesquisa e moeda
test/                      Testes de domínio e widgets
tool/check_domain.dart     Verificação offline do domínio
images/                    Imagens locais usadas pelo aplicativo
web/                       Arquivos de entrada da plataforma web
android/                   Projeto nativo Android e Gradle Wrapper
docs/documentacao.pdf      Documentação para entrega
docs/VALIDACAO.md           Matriz e roteiro de validação
.github/workflows/         Análise, testes e build no GitHub Actions
```

## Correspondência com o roteiro

| Requisito | Implementação |
| --- | --- |
| MaterialApp, Scaffold e AppBar | `ExploreMundoApp`, `ExploreHome` e `DestinationPage` |
| Imagem e assets no pubspec | `Image.asset`, `images/lake.jpg` e demais fotos |
| Seção de título com Expanded | `titleSection` em `DestinationPage` |
| Seção de botões em Row | `_buildButtonColumn`, `MainAxisAlignment.spaceEvenly` |
| Texto com preenchimento e softWrap | `textSection` |
| Rolagem em ListView | Tela inicial e detalhes |
| Sobreposição/Stack | Banner com imagem, degradê e texto |
| Interatividade | Pesquisa, favoritos, comentários e simulações |
| Documentação em PDF | `docs/documentacao.pdf` |

Os widgets Material utilizam o pacote oficial `material_ui`, conforme a migração do Flutter atual. O roteiro menciona RaisedButton; este projeto utiliza **ElevatedButton**, seu substituto atual no Flutter.

## Gerar novamente a documentação

```sh
python -m pip install -r tool/requirements-docs.txt
python tool/generate_documentation.py
```

## Entregar

1. Confira o código e execute as verificações acima no Flutter.
2. Se necessário, adicione capturas reais da execução a `docs/` e atualize o relatório.
3. Confirme que `docs/documentacao.pdf` aparece no repositório.
4. Envie o link do repositório na Sala de Aula Virtual, aba **Trabalhos**, do nível correspondente.
5. Se o repositório for privado, conceda ao tutor o acesso necessário antes da entrega.

## Imagens e referências

Fotografias obtidas do Unsplash (licença Unsplash), incorporadas como assets para demonstração:

- Lago: identificador da imagem: `photo-1476514525535-07fb3b4ae5f1`.
- Montanhas: imagem `photo-1464822759023-fed622ff2c3b` de https://images.unsplash.com/.
- Praia: imagem `photo-1507525428034-b723cf961d3e` de https://images.unsplash.com/.

As imagens ilustram categorias de paisagem; não comprovam os locais dos pacotes fictícios. Fontes exatas em `images/CREDITOS.md`.

- Roteiro da disciplina: https://sway.cloud.microsoft/4hFJo0qpdyvzSSFk
- Layout oficial Flutter: https://docs.flutter.dev/ui/layout/tutorial
- Widgets básicos: https://docs.flutter.dev/ui/widgets/basics
- Instalação: https://docs.flutter.dev/install

- Widgets Material atuais: https://pub.dev/packages/material_ui
