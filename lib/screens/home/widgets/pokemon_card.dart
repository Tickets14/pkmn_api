import 'package:flutter/material.dart';
import 'package:pkmn_api/models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: Text("${pokemon.id}"),
        leading: _buildPokemonImage(),
        title: Text(pokemon.name),
      ),
    );
  }

  Widget _buildPokemonImage() {
    return FadeInImage.assetNetwork(
      placeholder:
          './assets/images/default_pokemon.png', // Replace with your placeholder image path
      image: pokemon.image,
      fit: BoxFit.cover,
      width: 60, // Adjust the width as needed
      height: 60, // Adjust the height as needed
    );
  }
}
