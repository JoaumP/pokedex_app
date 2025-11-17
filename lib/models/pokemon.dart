/// Modelo simples que representa um Pokémon carregado da API.
///
/// Contém apenas os campos necessários para a exibição na app:
/// - `id`: identificador numérico do Pokémon (ex: 1 para Bulbasaur)
/// - `name`: nome do Pokémon
/// - `imageUrl`: URL da imagem (sprite) usada nos cards/detalhes
/// - `types`: lista de tipos (ex: ['grass', 'poison'])
class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  /// Cria uma instância de [Pokemon] a partir de um JSON retornado pela PokeAPI.
  ///
  /// Esta fábrica facilita testes e possíveis usos futuros; não altera o
  /// comportamento atual, pois o serviço já cria os objetos manualmente.
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['sprites'] != null ? json['sprites']['front_default'] as String? ?? '' : '',
      types: (json['types'] as List<dynamic>?)
              ?.map((t) => t['type']['name'] as String)
              .toList() ??
          [],
    );
  }

}