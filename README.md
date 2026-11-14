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

Instale o Flutter SDK estável com Dart >= 3.10, Git e Chrome. Depois:

```sh
flutter doctor
flutter pub get
flutter run -d chrome
```

Os arquivos de plataforma web estão incluídos. O Flutter compilará o aplicativo e servirá as imagens locais, sem depender de fotos remotas durante o uso.

## Executar no Android

Instale também Android Studio, Android SDK e um emulador ou conecte um aparelho com depuração USB. Gere os arquivos nativos no próprio diretório do projeto:

```sh
flutter create --platforms=android --org br.com.jeferson --project-name explore_mundo .
flutter pub get
flutter devices
flutter run -d ID_DO_DISPOSITIVO
```

O comando `flutter create` sem `--overwrite` preserva o código existente. Os arquivos nativos Android ainda não foram gerados neste ambiente; a distribuição incluída está preparada para web. No Windows, execute os mesmos comandos no terminal do VS Code ou PowerShell.

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

**Resultado realmente verificado neste ambiente:** 9 verificações do domínio passaram; os 5 arquivos Dart passaram pelo formatador. Os 3 JPEGs e o PDF foram conferidos. **A análise Flutter, os testes de widgets e a compilação não foram executados**, pois a inicialização do Flutter foi bloqueada por uma tentativa de acesso a metadados da infraestrutura. Não há APK nem screenshots de execução anexados. A automação em `.github/workflows/flutter.yml` executa os checks completos após o push; o resultado deve ser conferido na aba Actions antes da entrega.

## Estrutura

```text
lib/main.dart              Aplicativo, telas, componentes e formulários
lib/destination.dart       Modelo, catálogo, pesquisa e moeda
test/                      Testes de domínio e widgets
tool/check_domain.dart     Verificação offline do domínio
images/                    Imagens locais usadas pelo aplicativo
web/                       Arquivos de entrada da plataforma web
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

O roteiro menciona RaisedButton; este projeto utiliza **ElevatedButton**, seu substituto atual no Flutter.

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
