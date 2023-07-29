import 'package:flutter/material.dart';
import 'package:pkmn_api/services/auth.dart';

class SignInPage extends StatefulWidget {
  final toggleView;

  SignInPage({super.key, required this.toggleView});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
          title: Text("Sign In"),
          actions: [
            IconButton(
                onPressed: () {
                  widget.toggleView();
                },
                icon: Icon(Icons.app_registration))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
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
                  SizedBox(
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
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result = await _auth.signInWithEmailAndPass(
                              email, password);
                          if (result == null) {
                            setState(() {
                              error = "Wrong Password";
                            });
                          }
                        }
                      },
                      child: Text("Sign In")),
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
