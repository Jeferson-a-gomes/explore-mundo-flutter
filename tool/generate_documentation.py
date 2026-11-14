from pathlib import Path
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, Image, KeepTogether
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from PIL import Image as PILImage
root=Path(__file__).resolve().parents[1]
styles=getSampleStyleSheet()
styles.add(ParagraphStyle(name='TitleX',fontName='Helvetica-Bold',fontSize=34,leading=39,textColor=colors.HexColor('#163A3A'),spaceAfter=18))
styles.add(ParagraphStyle(name='HeadX',fontName='Helvetica-Bold',fontSize=20,leading=25,textColor=colors.HexColor('#163A3A'),spaceAfter=14))
styles.add(ParagraphStyle(name='SubX',fontName='Helvetica-Bold',fontSize=12,leading=17,textColor=colors.HexColor('#147D73'),spaceBefore=12,spaceAfter=7))
styles.add(ParagraphStyle(name='BodyX',fontSize=10.5,leading=16,spaceAfter=10,textColor=colors.HexColor('#334F49')))
styles.add(ParagraphStyle(name='CodeX',fontName='Courier',fontSize=8.5,leading=13,backColor=colors.HexColor('#EEF3EF'),borderPadding=10,spaceAfter=15))
styles.add(ParagraphStyle(name='SmallX',fontSize=8.5,leading=12,textColor=colors.HexColor('#526960'),spaceAfter=9))
story=[]
def p(text,style='BodyX'): story.append(Paragraph(text,styles[style]))
def h(text): p(text,'HeadX')
def table(rows,widths):
    cells=[[Paragraph(str(c),styles['SmallX']) for c in row] for row in rows]
    t=Table(cells,colWidths=widths,hAlign='LEFT')
    t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#DFEBE4')),('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),9),('RIGHTPADDING',(0,0),(-1,-1),9),('TOPPADDING',(0,0),(-1,-1),9),('BOTTOMPADDING',(0,0),(-1,-1),7),('LINEBELOW',(0,0),(-1,-1),.35,colors.HexColor('#D2DFD8'))]))
    story.append(t)
def page(): story.append(PageBreak())
p('DGT2812 · TRABALHO PRÁTICO','SubX')
p('Explore<br/>Mundo','TitleX')
p('Desenvolvimento de Aplicativos Móveis com Flutter','HeadX')
p('Jeferson Augusto Gomes<br/>Estácio · 14 de novembro de 2026')
im=PILImage.open(root/'images/lake.jpg'); w,hh=im.size
story.append(Image(str(root/'images/lake.jpg'),width=475,height=220,kind='proportional'))
story.append(Spacer(1,20))
p('Documentação técnica e funcional de um protótipo de agência de viagens. '
  'O aplicativo reúne descoberta de destinos, pacotes, contato e interações em Flutter.')
p('Natureza da entrega: código-fonte, assets, testes e documentação. '
  'Preços, avaliações e reservas são fictícios; nenhuma transação real é realizada.','SmallX')
page();h('1. Objetivo e escopo')
p('Desenvolver a solução solicitada para a agência fictícia Explore Mundo, aplicando composição de widgets, '
  'organização visual e interatividade. O projeto adapta o roteiro da disciplina e acrescenta pesquisa e simulações locais.')
p('Experiência do usuário','SubX')
for title,body in [
 ('Descobrir','O visitante visualiza um banner de destaque e um catálogo de três pacotes, com imagem, região, duração, preço e avaliação.'),
 ('Pesquisar','O campo de pesquisa filtra o catálogo por palavras, ignorando maiúsculas e acentos. Consultas sem correspondência têm orientação visível.'),
 ('Conhecer','O banner e os cartões abrem a tela de detalhes: foto, título, localização, estrela, descrição e experiências incluídas.'),
 ('Interagir','O visitante pode favoritar, copiar um resumo, comentar e simular uma reserva, além de usar o formulário de contato.')]:
 p(title,'SubX');p(body)
p('Limites do protótipo','SubX')
p('Não utiliza backend ou serviço de pagamentos. Formulários não enviam dados; a ação de copiar grava apenas o resumo do destino na área de transferência. '
  'Favoritos, comentários e reservas permanecem na memória da sessão e são perdidos ao recarregar. '
  'Os botões Contato e Rota exibem informações locais, sem discagem telefônica ou navegação GPS.')
p('Imagens ilustrativas do Unsplash são incluídas como assets. Os nomes e dados dos pacotes são fictícios e não devem ser interpretados como ofertas reais. '
  'O crédito e os URLs exatos estão em images/CREDITOS.md.','SmallX')
page();h('2. Arquitetura e widgets')
p('A aplicação separa o catálogo e as funções de domínio da apresentação. O estado fica em StatefulWidget, sem dependências externas de gerenciamento de estado.')
table([['Arquivo / componente','Responsabilidade'],
 ['lib/destination.dart','Modelo imutável Destination, catálogo, normalização da pesquisa e formatação de moeda.'],
 ['ExploreMundoApp','Configura MaterialApp, tema, cores e tela inicial.'],
 ['ExploreHome','Navegação superior, pesquisa e estado compartilhado de favoritos, comentários e reservas.'],
 ['DestinationPage','Tela com imagem, título, botões, texto e formulário de reserva.'],
 ['FeaturedBanner / DestinationCard','Componentes reutilizáveis do catálogo; abertura dos detalhes.'],
 ['ContactForm','Validação local dos campos e confirmação demonstrativa.']], [165,310])
p('Correspondência com o roteiro','SubX')
table([['Requisito','Aplicação no código'],
 ['MaterialApp, Scaffold, AppBar','Estrutura e navegação das telas.'],
 ['Row, Column, Expanded','Seção de título, botões e cartões.'],
 ['Container e Text.softWrap','Preenchimento e descrição do destino.'],
 ['Image.asset + pubspec.yaml','Três imagens locais declaradas como recursos.'],
 ['ListView','Rolagem das seções e suporte a telas menores.'],
 ['Stack','Banner com fotografia, degradê e texto sobrepostos.'],
 ['Widget personalizado / interação','Favoritos, pesquisa, comentários e simulações.']], [165,310])
p('Os componentes Material utilizam o pacote oficial material_ui. ElevatedButton é utilizado no lugar do antigo RaisedButton citado no material. '
  'A navegação superior é rolável horizontalmente em telas estreitas. O conteúdo tem largura máxima em telas amplas.','SmallX')
page();h('3. Execução e uso')
p('Ambiente','SubX')
p('Flutter SDK 3.50 ou superior com Dart 3.13 ou superior, Git e Google Chrome. Para Android, instalar também Android Studio, SDK Android e um emulador ou dispositivo com depuração USB.')
p('Execução web','SubX')
p('flutter doctor<br/>flutter pub get<br/>flutter run -d chrome','CodeX')
p('O diretório web/ já está incluído. As fotos são carregadas do projeto e não exigem acesso remoto durante o uso. A primeira resolução de dependências e o download dos artefatos do Flutter exigem conexão.')
p('Preparação Android','SubX')
p('A estrutura nativa Android e o Gradle Wrapper estão incluídos. Inicie um emulador ou conecte um aparelho com depuração USB:')
p('flutter pub get<br/>flutter devices<br/>flutter run -d ID_DO_DISPOSITIVO','CodeX')
p('O arquivo android/local.properties contém caminhos específicos da máquina e não é versionado. O pubspec.lock registra as versões das dependências resolvidas.','SmallX')
p('Roteiro de demonstração','SubX')
for t in ['1. Pesquisar por SUICA, conferir o resultado e limpar a consulta.',
          '2. Abrir o banner, examinar título, estrelas, localização e descrição.',
          '3. Favoritar e voltar; reabrir para verificar o estado durante a sessão.',
          '4. Simular reserva com dados fictícios e consultar Pacotes de viagem.',
          '5. Publicar comentário, abrir Contato e testar a validação dos campos.']:
 p(t)
page();h('4. Validação e entrega')
p('Evidências obtidas em 14/11/2026','SubX')
p('<b>9 verificações offline passaram:</b> pesquisa sem acentos; pesquisa sem distinção de caixa; combinação de termos; '
  'ausência de resultados; catálogo completo; moeda brasileira; valor zero; agrupamento de milhões; identificadores únicos. '
  'O formatador Dart foi aplicado aos cinco arquivos. Os três JPEGs foram decodificados e a documentação foi renderizada para inspeção.')
p('Validação confirmada no GitHub Actions','SubX')
p('<b>Formatação aprovada, flutter analyze sem problemas, 7 testes aprovados e builds web release e Android debug concluídos.</b> '
  'A suíte verifica pesquisa, favoritos, validação e cancelamento de reserva, registro de solicitação e ausência de overflow em telas de 320 px. '
  'Ambiente: Flutter 3.50.0. Referência: execução 43628180929, em 14/11/2026.')
p('A estrutura Android está incluída. O APK de debug e o site compilado foram publicados como artefatos da execução, na aba Actions. '
  'Não foi realizado teste em aparelho físico nem inspeção visual interativa do aplicativo compilado.','SmallX')
p('Comandos de validação','SubX')
p('dart tool/check_domain.dart<br/>flutter analyze<br/>flutter test<br/>flutter build web --release','CodeX')
p('O workflow .github/workflows/flutter.yml prepara Flutter, verifica formatação, analisa o projeto, executa testes e compila web no GitHub Actions. '
  'O roteiro manual complementar encontra-se em docs/VALIDACAO.md.')
p('Procedimento de entrega','SubX')
p('Revisar o projeto, executar os testes no Flutter e manter este PDF em docs/documentacao.pdf no Git. '
  'Enviar o link do repositório ao tutor pela Sala de Aula Virtual, aba Trabalhos, do nível correspondente. '
  'Se o repositório for privado, garantir o acesso do tutor. Verificar o prazo na plataforma antes de enviar.')
p('Referências','SubX')
for t in ['Roteiro DGT2812: https://sway.cloud.microsoft/4hFJo0qpdyvzSSFk',
          'Flutter - layout: https://docs.flutter.dev/ui/layout/tutorial',
          'Flutter - widgets: https://docs.flutter.dev/ui/widgets/basics',
          'Flutter - instalação: https://docs.flutter.dev/install',
          'Unsplash - licença: https://unsplash.com/license']:
 p(t,'SmallX')
def footer(c,d):
 c.setStrokeColor(colors.HexColor('#D2DFD8'));c.line(60,43,535,43)
 c.setFont('Helvetica',8);c.setFillColor(colors.HexColor('#61736C'))
 c.drawString(60,30,'EXPLORE MUNDO  |  Jeferson Augusto Gomes  |  DGT2812')
 c.drawRightString(535,30,str(d.page))
doc=SimpleDocTemplate(str(root/'docs/documentacao.pdf'),pagesize=(595.28,841.89),rightMargin=60,leftMargin=60,topMargin=55,bottomMargin=60,title='Explore Mundo - Documentação do projeto Flutter',author='Jeferson Augusto Gomes')
doc.build(story,onFirstPage=footer,onLaterPages=footer)
for f in (root/'images').glob('*.jpg'):
 with PILImage.open(f) as im: im.verify()
print('PDF e 3 imagens verificados.')
