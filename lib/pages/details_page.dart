import 'package:flutter/material.dart';
import '../models/pokemon.dart';

/// Página de detalhes do Pokémon.
///
/// Exibe a imagem em destaque, tipos, ID e outras informações estilizadas
/// com base no(s) tipo(s) do Pokémon.
class DetailsPage extends StatelessWidget {
  /// O Pokémon cujos detalhes serão exibidos.
  final Pokemon pokemon;

  const DetailsPage({Key? key, required this.pokemon}) : super(key: key);

  /// Retorna uma cor base associada ao [type].
  ///
  /// A função normaliza o texto para minúsculas e escolhe uma cor representativa
  /// para cada tipo conhecido. Se o tipo não for reconhecido, retorna cinza.
  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return Colors.brown.shade300;
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amberAccent.shade700;
      case 'ice':
        return Colors.cyanAccent;
      case 'fighting':
        return Colors.deepOrange;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown.shade400;
      case 'flying':
        return Colors.indigoAccent;
      case 'psychic':
        return Colors.pinkAccent;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Colors.orange.shade700;
      case 'ghost':
        return Colors.deepPurple.shade700;
      case 'dragon':
        return Colors.deepPurple;
      default:
        // Cor padrão para tipos desconhecidos
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usa a cor do primeiro tipo do Pokémon como cor principal da tela
    final mainColor = _typeColor(pokemon.types.first);

    return Scaffold(
      // Fundo suave com opacidade baseada na cor do tipo
      backgroundColor: mainColor.withOpacity(0.15),
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: Text(
          // Nome em maiúsculas para destaque
          pokemon.name.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // IMAGEM DESTACADA: usa Hero para animação entre telas
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Hero(
                tag: pokemon.id,
                child: Image.network(
                  pokemon.imageUrl,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CARD DE INFORMAÇÕES: exibe ID, nome, tipos e região
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.15),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ID formatado com zero à esquerda (ex: #001)
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Nome em destaque
                  Text(
                    pokemon.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TIPOS COMO CHIPS: mapeia cada tipo para um pequeno badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pokemon.types.map((type) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          // Fundo do chip com baixa opacidade da cor do tipo
                          color: _typeColor(type).withOpacity(0.20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          type.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _typeColor(type),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // REGIÃO: atualmente hardcoded como 'Kanto'.
                  // Se for necessário suportar várias regiões, substituir por dado do modelo.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.public, color: mainColor, size: 26),
                      const SizedBox(width: 8),
                      Text(
                        'Região: Kanto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
