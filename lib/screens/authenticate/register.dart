import 'package:flutter/material.dart';

import '../../services/auth.dart';

class RegisterPage extends StatefulWidget {
  final toggleView;
  const RegisterPage({super.key, required this.toggleView});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          title: const Text("Register Here"),
          actions: [
            IconButton(
                onPressed: () {
                  widget.toggleView();
                },
                icon: const Icon(Icons.login))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.length < 6 ? 'Enter a pass 6+ character' : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result = await _auth.registerWithEmailAndPass(
                              email, password);
                          if (result == null) {
                            setState(() {
                              error = "please supply a valid email";
                            });
                          }
                        }
                      },
                      child: const Text("Register")),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    error,
                  )
                ],
              )),
        ));
  }
}
