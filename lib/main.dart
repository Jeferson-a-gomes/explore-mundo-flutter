import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'destination.dart';

void main() => runApp(const ExploreMundoApp());

const ink = Color(0xFF163A3A);
const teal = Color(0xFF147D73);
const paper = Color(0xFFF5F6F2);

class ExploreMundoApp extends StatelessWidget {
  const ExploreMundoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Explore Mundo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: teal),
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDAE3DF)),
        ),
      ),
    ),
    home: const ExploreHome(),
  );
}

class ExploreHome extends StatefulWidget {
  const ExploreHome({super.key});
  @override
  State<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends State<ExploreHome> {
  int section = 0;
  String query = '';
  final search = TextEditingController();
  final scroll = ScrollController();
  final favorites = <String>{};
  final comments = <String, List<String>>{};
  final reservations = <String>[];
  static const sections = [
    'Destinos',
    'Pacotes de viagem',
    'Contato',
    'Sobre nós',
  ];

  @override
  void dispose() {
    search.dispose();
    scroll.dispose();
    super.dispose();
  }

  void navigate(int index) {
    setState(() => section = index);
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  Future<void> openDestination(Destination destination) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DestinationPage(
          destination: destination,
          initialFavorite: favorites.contains(destination.id),
          comments: comments.putIfAbsent(destination.id, () => []),
          onFavorite: (selected) => setState(() {
            if (selected) {
              favorites.add(destination.id);
            } else {
              favorites.remove(destination.id);
            }
          }),
          onReserve: (summary) => setState(() => reservations.add(summary)),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final results = searchDestinations(query);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.explore_outlined, color: teal),
            SizedBox(width: 8),
            Text(
              'Explore Mundo',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: sections.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) => ChoiceChip(
                label: Text(sections[index]),
                selected: section == index,
                onSelected: (_) => navigate(index),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: ListView(
                  controller: scroll,
                  padding: const EdgeInsets.all(20),
                  children: switch (section) {
                    0 => [
                      const Eyebrow('VIAJE PARA ALÉM DO ÓBVIO'),
                      const SizedBox(height: 8),
                      const Text(
                        'Seu próximo capítulo\ncomeça aqui.',
                        style: TextStyle(
                          fontSize: 34,
                          height: 1.12,
                          fontWeight: FontWeight.w800,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Encontre paisagens, experiências e tempo para você.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5A6C66),
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        key: const Key('search'),
                        controller: search,
                        onChanged: (value) => setState(() => query = value),
                        decoration: InputDecoration(
                          hintText: 'Qual é o seu próximo destino?',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: query.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Limpar pesquisa',
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    search.clear();
                                    setState(() => query = '');
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (query.trim().isEmpty) ...[
                        FeaturedBanner(
                          destination: destinations.first,
                          onTap: () => openDestination(destinations.first),
                        ),
                        const SizedBox(height: 28),
                      ],
                      Text(
                        query.trim().isEmpty
                            ? 'Inspire sua próxima viagem'
                            : '${results.length} destino(s) encontrado(s)',
                        style: const TextStyle(
                          fontSize: 22,
                          color: ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (results.isEmpty)
                        const InfoPanel(
                          title: 'Nenhum destino encontrado',
                          text:
                              'Tente buscar por lago, montanhas, praia, Brasil ou Suíça.',
                        ),
                      ...results.map(
                        (d) => DestinationCard(
                          destination: d,
                          favorite: favorites.contains(d.id),
                          onTap: () => openDestination(d),
                        ),
                      ),
                      const DemoNotice(),
                    ],
                    1 => [
                      const PageHeading(
                        'Pacotes de viagem',
                        'Escolha uma experiência e simule sua reserva.',
                      ),
                      ...destinations.map(
                        (d) => DestinationCard(
                          destination: d,
                          favorite: favorites.contains(d.id),
                          onTap: () => openDestination(d),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Suas solicitações nesta sessão',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (reservations.isEmpty)
                        const Text('Você ainda não simulou nenhuma reserva.'),
                      ...reservations.map(
                        (r) => Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle_outline,
                              color: teal,
                            ),
                            title: Text(r),
                          ),
                        ),
                      ),
                      const DemoNotice(),
                    ],
                    2 => const [
                      PageHeading(
                        'Vamos conversar?',
                        'Um bom roteiro começa com uma boa conversa.',
                      ),
                      InfoPanel(
                        title: 'Contato demonstrativo',
                        text:
                            'Explore Mundo é uma agência fictícia criada para esta prática acadêmica. '
                            'Nenhuma mensagem é enviada a uma empresa real.',
                      ),
                      SizedBox(height: 20),
                      ContactForm(),
                      DemoNotice(),
                    ],
                    _ => const [
                      PageHeading(
                        'Sobre a Explore Mundo',
                        'Experiências que cabem em uma boa história.',
                      ),
                      InfoPanel(
                        title: 'Nosso propósito',
                        text:
                            'Um protótipo de agência de viagens '
                            'que facilita a descoberta de destinos e a consulta de pacotes. '
                            'A interface reúne imagens, localização, avaliações e ações em um layout com rolagem.',
                      ),
                      SizedBox(height: 16),
                      InfoPanel(
                        title: 'Projeto acadêmico · DGT2812',
                        text:
                            'Desenvolvimento de Aplicativos '
                            'Móveis com Flutter. Autor: Jeferson Augusto Gomes. '
                            'MaterialApp, Scaffold, AppBar, ListView, Row, Column, Expanded, '
                            'Container, Text, Image.asset, Stack e widgets interativos.',
                      ),
                      DemoNotice(),
                    ],
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      letterSpacing: 2,
      color: teal,
      fontWeight: FontWeight.w800,
    ),
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
        const SizedBox(height: 12),
        Text(subtitle),
      ],
    ),
  );
}

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({
    super.key,
    required this.destination,
    required this.onTap,
  });
  final Destination destination;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Conhecer ${destination.name}',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 280,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                destination.image,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xDD102C2C)],
                  ),
                ),
              ),
              Positioned(
                left: 22,
                right: 22,
                bottom: 22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DESTINO EM DESTAQUE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      destination.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Text(
                          'Explore essa experiência',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.destination,
    required this.favorite,
    required this.onTap,
  });
  final Destination destination;
  final bool favorite;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            destination.image,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            semanticLabel: 'Paisagem ilustrativa de ${destination.name}',
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        destination.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                    ),
                    if (favorite)
                      const Icon(Icons.favorite, color: teal, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Text(destination.location),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Text(
                      '★ ${destination.rating} · ${destination.reviews} avaliações',
                      style: const TextStyle(color: teal),
                    ),
                    Text(
                      '${destination.days} dias · ${money(destination.price)} / pessoa',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ver destino e pacote →',
                  style: TextStyle(color: teal, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class DestinationPage extends StatefulWidget {
  const DestinationPage({
    super.key,
    required this.destination,
    required this.initialFavorite,
    required this.comments,
    required this.onFavorite,
    required this.onReserve,
  });
  final Destination destination;
  final bool initialFavorite;
  final List<String> comments;
  final ValueChanged<bool> onFavorite;
  final ValueChanged<String> onReserve;
  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  late bool favorite = widget.initialFavorite;
  final comment = TextEditingController();
  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  void info(String title, String content) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendi'),
        ),
      ],
    ),
  );

  // Reutiliza a composição Column + ícone + rótulo solicitada no roteiro.
  Widget _buildButtonColumn(IconData icon, String label, VoidCallback onTap) =>
      TextButton(
        onPressed: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: teal),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      );

  Future<void> reserve() async {
    final form = GlobalKey<FormState>();
    int people = 1;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Simular reserva'),
          content: SingleChildScrollView(
            child: Form(
              key: form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Não há cobrança nem envio de dados. Use dados fictícios.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: requiredText,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: validEmail,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: people,
                    decoration: const InputDecoration(labelText: 'Viajantes'),
                    items: List.generate(
                      6,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text('${i + 1}'),
                      ),
                    ),
                    onChanged: (value) => update(() => people = value ?? 1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total fictício: ${money(widget.destination.price * people)}',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (form.currentState!.validate())
                  Navigator.pop(dialogContext, true);
              },
              child: const Text('Confirmar simulação'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || accepted != true) return;
    final summary =
        '${widget.destination.name} · $people viajante(s) · ${money(widget.destination.price * people)}';
    widget.onReserve(summary);
    info(
      'Simulação registrada',
      '$summary\n\nSolicitação apenas nesta sessão. Nenhuma reserva real foi efetuada.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    final titleSection = Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.name,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  d.location,
                  style: const TextStyle(color: Color(0xFF61736C)),
                ),
              ],
            ),
          ),
          const Icon(Icons.star, color: Color(0xFFC08018)),
          const SizedBox(width: 4),
          Text(
            '${d.rating}\n${d.reviews} avaliações',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    final textSection = Container(
      padding: const EdgeInsets.all(24),
      child: Text(
        d.description,
        softWrap: true,
        style: const TextStyle(fontSize: 16, height: 1.65),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conheça seu destino'),
        actions: [
          IconButton(
            tooltip: favorite
                ? 'Remover dos favoritos'
                : 'Adicionar aos favoritos',
            icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() => favorite = !favorite);
              widget.onFavorite(favorite);
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            children: [
              Image.asset(
                d.image,
                width: 600,
                height: 280,
                fit: BoxFit.cover,
                semanticLabel: 'Paisagem ilustrativa de ${d.name}',
              ),
              titleSection,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButtonColumn(
                    Icons.call_outlined,
                    'CONTATO',
                    () => info(
                      'Contato da agência',
                      'Esta é uma agência fictícia. A seção Contato da tela inicial demonstra o formulário de atendimento.',
                    ),
                  ),
                  _buildButtonColumn(
                    Icons.near_me_outlined,
                    'ROTA',
                    () => info(
                      'Localização',
                      '${d.location}\n\nConsulte as condições e o trajeto com a equipe antes de uma viagem. Este protótipo não fornece navegação GPS.',
                    ),
                  ),
                  _buildButtonColumn(Icons.share_outlined, 'COPIAR', () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text:
                            '${d.name} | ${d.location} | Explore Mundo - demonstração acadêmica',
                      ),
                    );
                    if (context.mounted)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Resumo copiado.')),
                      );
                  }),
                ],
              ),
              textSection,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('SEU ROTEIRO'),
                    const SizedBox(height: 12),
                    ...d.experiences.map(
                      (e) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.check_circle_outline,
                          color: teal,
                        ),
                        title: Text(e),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${money(d.price)} / pessoa',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: ink,
                      ),
                    ),
                    Text('${d.days} dias · valor fictício'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: reserve,
                      icon: const Icon(Icons.luggage_outlined),
                      label: const Text('Simular reserva'),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Compartilhe sua experiência',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: comment,
                      maxLines: 3,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: 'Comentário demonstrativo',
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Publicar nesta sessão'),
                      onPressed: () {
                        final value = comment.text.trim();
                        if (value.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Escreva um comentário.'),
                            ),
                          );
                          return;
                        }
                        setState(() => widget.comments.add(value));
                        comment.clear();
                      },
                    ),
                    ...widget.comments.map(
                      (c) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(c),
                          subtitle: const Text('Visitante · nesta sessão'),
                        ),
                      ),
                    ),
                    const DemoNotice(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? requiredText(String? value) => value == null || value.trim().length < 2
    ? 'Informe pelo menos 2 caracteres.'
    : null;
String? validEmail(String? value) =>
    value != null &&
        RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())
    ? null
    : 'Informe um e-mail válido.';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});
  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => Form(
    key: form,
    child: Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Seu nome fictício'),
          validator: requiredText,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(labelText: 'E-mail fictício'),
          keyboardType: TextInputType.emailAddress,
          validator: validEmail,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Como podemos ajudar?'),
          maxLines: 4,
          maxLength: 1000,
          validator: requiredText,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.mail_outline),
          label: const Text('Simular envio'),
          onPressed: () {
            if (!form.currentState!.validate()) return;
            form.currentState!.reset();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Simulação concluída. Nenhuma mensagem foi enviada.',
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key, required this.title, required this.text});
  final String title, text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
        const SizedBox(height: 12),
        Text(text, style: const TextStyle(height: 1.6)),
      ],
    ),
  );
}

class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 28),
    child: Text(
      'EXPLORE MUNDO · PROJETO ACADÊMICO\nPreços e avaliações fictícios. '
      'Reservas, favoritos e comentários ficam apenas na sessão e são perdidos ao reiniciar o app.',
      style: TextStyle(fontSize: 12, color: Color(0xFF61736C), height: 1.6),
    ),
  );
}
