import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

/// Serviço responsável por se comunicar com a PokeAPI.
///
/// Atualmente busca a lista básica de pokémons (`/pokemon?limit=&offset=`)
/// e, para cada resultado, realiza uma requisição adicional para obter
/// detalhes (sprites, tipos, id). Note que as requisições de detalhe são
/// sequenciais aqui; para performance, considerar paralelizar com
/// `Future.wait` se necessário.
class PokeApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  /// Busca uma lista de [Pokemon] paginada.
  ///
  /// - [limit]: número de itens por página (padrão 10)
  /// - [offset]: deslocamento (padrão 0)
  ///
  /// Ajustes internos:
  /// - Limita a busca ao máximo de 151 itens (primeira geração).
  /// - Se o `offset` já exceder o máximo, retorna lista vazia.
  Future<List<Pokemon>> fetchPokemons({int limit = 10, int offset = 0}) async {
    const int max = 151;

    // Ajusta o limit caso ultrapasse o máximo disponível
    if (offset + limit > max) {
      limit = max - offset;
    }

    // Se o offset já for >= max, não há itens a buscar
    if (offset >= max) {
      return [];
    }
    
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit&offset=$offset'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      List<Pokemon> pokemons = [];
      // Para cada resultado da listagem, buscamos os detalhes do Pokémon
      for (var item in results) {
        final detailResponse = await http.get(Uri.parse(item['url']));
        if (detailResponse.statusCode == 200) {
          final detailData = jsonDecode(detailResponse.body);
          // Cria o modelo Pokemon a partir dos dados de detalhe
          pokemons.add(
            Pokemon(
            id: detailData['id'],
            name: detailData['name'],
            imageUrl: detailData['sprites']['front_default'],
            types: (detailData['types'] as List)
              .map((t) => t['type']['name'] as String)
              .toList(),
            )
          );
        }
      }
      return pokemons;
    } else {
      // Propaga um erro para ser tratado pelo consumidor (UI, testes, etc.)
      throw Exception('Falha ao carregar Pokémons');
    }
  }
}