import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/poke_api_service.dart';
import '../widgets/pokemon_card.dart';

/// Página inicial (lista) da Pokédex.
///
/// Responsável por buscar páginas de Pokémons via [PokeApiService] e
/// exibir em um grid com paginação simples.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future que contém a lista de pokémons carregada atualmente.
  late Future<List<Pokemon>> _pokemonFuture;

  // Serviço responsável pelas requisições à PokéAPI.
  final PokeApiService _pokeApiService = PokeApiService();

  // Offset usado para paginação (0-based). Aqui cada página carrega 10 itens.
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    // Inicia a primeira requisição ao criar o estado
    _pokemonFuture = _pokeApiService.fetchPokemons(offset: _offset);
  }

  /// Carrega a próxima página (incrementa o offset em 10).
  ///
  /// O limite máximo atual está definido no serviço (151), então este método
  /// apenas atualiza o estado e dispara uma nova chamada.
  void _loadNextPage() {
    if (_offset < 150) {
      setState(() {
        _offset += 10;
        _pokemonFuture = _pokeApiService.fetchPokemons(offset: _offset);
      });
    }
  }

  /// Carrega a página anterior (decrementa o offset em 10).
  void _loadPreviousPage() {
    if (_offset >= 10) {
      setState(() {
        _offset -= 10;
        _pokemonFuture = _pokeApiService.fetchPokemons(offset: _offset);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo com degradê vermelho -> branco para dar destaque ao header
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // Header: ícone e título centralizados
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.catching_pokemon, color: Colors.white, size: 32),
                    SizedBox(width: 10),
                    Text(
                      "Pokédex",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Lista principal dentro de um contêiner com cantos arredondados
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: FutureBuilder<List<Pokemon>>(
                    future: _pokemonFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        // Mostra loading enquanto busca os dados
                        return Center(
                            child: CircularProgressIndicator(
                                color: Colors.redAccent));
                      } else if (snapshot.hasError) {
                        // Exibe erro caso a requisição falhe
                        return Center(
                            child: Text('Erro: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        // Caso não haja pokémons a exibir
                        return Center(
                            child: Text('Nenhum Pokémon encontrado.'));
                      }

                      final pokemons = snapshot.data!;

                      // Grid responsivo que exibe os cards
                      return GridView.builder(
                        padding: EdgeInsets.all(12),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: pokemons.length,
                        itemBuilder: (context, index) {
                          return PokemonCard(pokemon: pokemons[index]);
                        },
                      );
                    },
                  ),
                ),
              ),

              // Barra de paginação com botões anterior/próximo
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // botão anterior (desativado no offset 0)
                    IconButton(
                      onPressed:
                          _offset == 0 ? null : _loadPreviousPage,
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color:
                            _offset == 0 ? Colors.grey : Colors.redAccent,
                      ),
                    ),

                    // Página atual calculada a partir do offset
                    Text(
                      "Página ${( _offset / 10 ).floor() + 1}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),

                    // botão próximo (desativado no offset máximo)
                    IconButton(
                      onPressed: _offset == 150 ? null : _loadNextPage,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.redAccent,
                      ),
                    ),
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
