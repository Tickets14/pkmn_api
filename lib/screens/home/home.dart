import 'package:flutter/material.dart';
import 'package:pkmn_api/models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pkmn_api/screens/home/widgets/pokemon_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Pokemon>> _pokemonList;
  int _itemsPerPage = 15;
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _offset = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pokemonList = fetchPokemons(_offset);
    _scrollController.addListener(_loadMorePokemons);
  }

  Future<List<Pokemon>> fetchPokemons(int offset) async {
    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$_itemsPerPage'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      final List<Pokemon> pokemonList = await fetchPokemonDetails(results);
      return pokemonList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Pokemon>> fetchPokemonDetails(List<dynamic> results) async {
    final List<Pokemon> pokemonList = [];
    for (var result in results) {
      final response = await http.get(Uri.parse(result['url']));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pokemon = Pokemon(
          name: data['name'],
          id: data['id'],
          image: data['sprites']['other']['official-artwork']['front_default'],
        );
        pokemonList.add(pokemon);
      } else {
        throw Exception('Failed to load data');
      }
    }
    return pokemonList;
  }

  void _loadMorePokemons() {
    if (_isLoading) return;

    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      setState(() {
        _isLoading = true;
      });

      _offset = 0; // Reset the offset to load recent Pokemon
      fetchPokemons(_offset).then((newPokemons) {
        setState(() {
          // Replace the existing list with the new data
          _pokemonList = Future.value(newPokemons);
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
      });
    } else if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoading = true;
      });

      _offset += _itemsPerPage; // Increment the offset to load more Pokemon
      fetchPokemons(_offset).then((newPokemons) {
        setState(() {
          // Append the new data to the existing list
          _pokemonList.then((existingPokemons) {
            existingPokemons.addAll(newPokemons);
            _isLoading = false;
          });
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Pokemon> _filterPokemonList(List<Pokemon> list, String query) {
    if (query.isEmpty) {
      return list;
    } else {
      return list
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Listen to scroll updates to trigger loading of recent Pokemon
          if (notification is ScrollUpdateNotification && !_isLoading) {
            if (notification.metrics.pixels <=
                notification.metrics.minScrollExtent) {
              _loadMorePokemons(); // Load recent Pokemon when user scrolls up to the top
            }
          }
          return false;
        },
        child: FutureBuilder<List<Pokemon>>(
          future: _pokemonList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final pokemonList =
                  _filterPokemonList(snapshot.data!, _searchQuery);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: _performSearch,
                      decoration: const InputDecoration(
                        labelText: 'Search Pokémon',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: pokemonList.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == pokemonList.length) {
                          return _buildLoadingIndicator();
                        } else {
                          final pokemon = pokemonList[index];
                          return PokemonCard(
                            pokemon: Pokemon(
                              name: pokemon.name,
                              id: pokemon.id,
                              image: pokemon.image,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}



// class HomePage extends StatelessWidget {
//  HomePage({super.key});

//   final AuthService _auth = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("HOMEPAGE"),
//         actions: <Widget>[
//           IconButton(onPressed: () async {
//             await _auth.signOut();
//           }, icon: Icon(Icons.logout))
//         ],
//       ),
//     );
//   }
// }