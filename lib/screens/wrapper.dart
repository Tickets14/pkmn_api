import 'package:flutter/material.dart';
import 'package:pkmn_api/models/myUser.dart';
import 'package:pkmn_api/screens/authenticate/authenticate.dart';
import 'package:pkmn_api/screens/home/home.dart';

import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print("WRAPPER FILE: $user");

    if (user == null) {
      return Authenticate();
    } else {
      return Homepage();
    }
  }
}
