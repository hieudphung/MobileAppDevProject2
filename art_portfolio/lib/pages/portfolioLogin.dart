import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './signUp.dart';

class PortfolioLogin extends StatefulWidget {
  PortfolioLogin({super.key});

  final _loginFormKey = GlobalKey<FormState>();

  @override
  State<PortfolioLogin> createState() => _PortfolioLoginState();
}

class _PortfolioLoginState extends State<PortfolioLogin> {
  String email = '';
  String password = '';

  Future<void> _submitLogin() async {
    final bool emailValid = 
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

    if (emailValid) {
      FirebaseAuth auth = FirebaseAuth.instance;

      try {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  void setEmail(String formValue) {
    email = formValue;
  }

  void setPassword(String formValue) {
    password = formValue;
  }

  void _goToSignupPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Flexible(
          flex: 3,
          child: Text('Login Here',
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
        ),
        Form (
          key: widget._loginFormKey,
          child: 
          Flexible(
            child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Email Here',
                ),
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Empty Task Entry!';
                  } else {
                    setEmail(value);
                  }
                  return null;
                },
              ),
            )
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Password Here',
                ),
                obscureText: true,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Empty Task Entry!';
                  } else {
                    setPassword(value);
                  }
                  return null;
                },
              ),
            )
          ),
          Flexible(
            child: ElevatedButton(
              child: const Text("Login"),
              onPressed: () async {
                if (widget._loginFormKey.currentState!.validate()) {
                  await _submitLogin();
                }
              },
            ),
          ),
        ]
      ),),
      ),
      const SizedBox(height: 60),
      Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ElevatedButton(
                child: const Text("Sign Up"),
                onPressed: () {
                  _goToSignupPage();
                },
              ),
            ),
          ),
        ),
      ]
    );
  }
}