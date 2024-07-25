import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/styling.dart';
import 'signUpPage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Portfolio App',
      theme: AppTheme.themeData,
      home: Scaffold(
            resizeToAvoidBottomInset : false,
            appBar: AppBar(title: const Text('Portfolio Login', style: AppTextStyles.headline1),
                           backgroundColor: AppColors.appBarColor),
            body: PortfolioLogin()),
    );
  }
}

class PortfolioLogin extends StatefulWidget {
  PortfolioLogin({super.key});

  @override
  State<PortfolioLogin> createState() => _PortfolioLoginState();
}

class _PortfolioLoginState extends State<PortfolioLogin> {
  final _loginFormKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  Future<void> _submitLogin() async {
    final bool emailValid = 
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

    bool loggedIn = false;

    if (emailValid) {
      FirebaseAuth auth = FirebaseAuth.instance;

      try {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password
        );
        loggedIn = true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          loggedIn = false;
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          loggedIn = false;
        }
      }
    }

    if (!loggedIn) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login unsuccessful!')));
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
                      style: AppTextStyles.headline2
                    ),
        ),
        const SizedBox(height: 30),
        Flexible(
          flex: 2,
          child:
          Card(
            color: AppColors.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Form (
          key: _loginFormKey,
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
          const SizedBox(height: 30),
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
          const SizedBox(height: 30),
          Flexible(
            child: ElevatedButton(
              style: AppButtonStyles.primaryButton,
              onPressed: () async {
                if (_loginFormKey.currentState!.validate()) {
                  await _submitLogin();
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fields empty!')));
                  }
                }
              },
              child: const Text("Login"),
            ),
          ),
        ]
      ),),
      ),),),),
      const SizedBox(height: 60),
      Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ElevatedButton(
                style: AppButtonStyles.secondaryButton,
                onPressed: () {
                  _goToSignupPage();
                },
                child: const Text("Sign Up"),
              ),
            ),
          ),
        ),
      ]
    );
  }
}