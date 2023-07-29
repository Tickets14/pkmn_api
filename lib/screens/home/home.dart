import 'package:flutter/material.dart';
import 'package:pkmn_api/services/auth.dart';

class HomePage extends StatelessWidget {
 HomePage({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOMEPAGE"),
        actions: <Widget>[
          IconButton(onPressed: () async {
            await _auth.signOut();
          }, icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
