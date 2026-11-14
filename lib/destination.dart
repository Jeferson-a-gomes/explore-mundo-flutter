/// Catálogo fictício: preços e avaliações servem somente à demonstração.
class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.description,
    required this.price,
    required this.days,
    required this.rating,
    required this.reviews,
    required this.experiences,
  });
  final String id, name, location, image, description;
  final int price, days, reviews;
  final double rating;
  final List<String> experiences;
}

const destinations = [
  Destination(
    id: 'lago',
    name: 'Refúgio dos Lagos',
    location: 'Alpes · Suíça',
    image: 'images/lake.jpg',
    price: 4590,
    days: 5,
    rating: 4.9,
    reviews: 41,
    description:
        'Uma pausa entre águas tranquilas e montanhas. Explore trilhas, '
        'contemple a paisagem e aproveite dias de descanso em um roteiro de natureza. '
        'O pacote demonstrativo reúne hospedagem, passeios guiados e tempo livre. '
        'As imagens são ilustrativas e não representam uma oferta comercial.',
    experiences: [
      'Passeios junto ao lago',
      'Trilhas guiadas',
      'Hospedagem incluída',
    ],
  ),
  Destination(
    id: 'montanhas',
    name: 'Horizontes das Montanhas',
    location: 'Cordilheira · Europa',
    image: 'images/mountains.jpg',
    price: 3290,
    days: 4,
    rating: 4.8,
    reviews: 28,
    description:
        'Descubra novos horizontes em um roteiro de montanha. Caminhadas '
        'leves, mirantes e contato com a natureza compõem esta experiência fictícia. '
        'Atividades dependem das condições locais. Consulte a equipe antes de viajar.',
    experiences: ['Visita a mirantes', 'Caminhadas leves', 'Guia local'],
  ),
  Destination(
    id: 'praia',
    name: 'Dias de Mar',
    location: 'Litoral · Brasil',
    image: 'images/beach.jpg',
    price: 1890,
    days: 3,
    rating: 4.7,
    reviews: 36,
    description:
        'Troque a rotina por dias perto do mar. Um roteiro demonstrativo '
        'com descanso, passeios e paisagens do litoral. Valores, avaliações e '
        'disponibilidade são fictícios, destinados ao trabalho acadêmico.',
    experiences: [
      'Passeio pelo litoral',
      'Café da manhã',
      'Tempo livre na praia',
    ],
  ),
];

String normalized(String value) {
  const source = 'áàãâäéèêëíìîïóòõôöúùûüç';
  const target = 'aaaaaeeeeiiiiooooouuuuc';
  var result = value.toLowerCase().trim();
  for (var i = 0; i < source.length; i++) {
    result = result.replaceAll(source[i], target[i]);
  }
  return result;
}

List<Destination> searchDestinations(String query) {
  final terms = normalized(query)
      .split(RegExp(r'\s+'))
      .where((v) => v.isNotEmpty);
  return destinations.where((d) {
    final text = normalized('${d.name} ${d.location} ${d.description}');
    return terms.every(text.contains);
  }).toList();
}

String money(int value) {
  final digits = value.toString();
  final grouped = digits.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]}.',
  );
  return 'R\$ $grouped,00';
}
