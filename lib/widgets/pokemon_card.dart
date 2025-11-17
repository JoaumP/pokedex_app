import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../pages/details_page.dart';

/// Card visual que representa um Pokémon na lista.
///
/// Mostra a imagem (sprite), ID, nome e tipos. Ao tocar no card, navega
/// para a `DetailsPage` usando uma animação `Hero` para a imagem.
class PokemonCard extends StatelessWidget {
  /// O Pokémon exibido neste card.
  final Pokemon pokemon;

  const PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  /// Retorna a cor associada a um tipo para uso em gradiente/fundo.
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
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ao tocar, navegamos para a tela de detalhes
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(pokemon: pokemon),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              _typeColor(pokemon.types.first).withOpacity(0.7),
              _typeColor(pokemon.types.first).withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero para animação suave da imagem entre telas
            Hero(
              tag: pokemon.id,
              child: Image.network(
                pokemon.imageUrl,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 10),
            // ID formatado (ex: #001)
            Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Nome
            Text(
              pokemon.name,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            // Tipos separados por vírgula
            Text(
              pokemon.types.join(', '),
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
