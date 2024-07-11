import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/StoreService.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: const Text("Sign Up"),
                           backgroundColor: Colors.indigo[200]),
            body: SignupBody());
  }
}

class SignupBody extends StatefulWidget {
  SignupBody({super.key});

  final _signupFormKey = GlobalKey<FormState>();

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  String newEmail = '';
  String newPassword = '';
  String verifyPassword = '';
  int errorFlag = 0;

  Future<void> _submitSignup() async {

    final bool emailValid = 
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(newEmail);

    final bool passwordsEqual = (newPassword == verifyPassword);

    //check if all are viable
    if (emailValid && passwordsEqual) {
      setState(() async {
        //Now do sign-up
        FirebaseAuth auth = FirebaseAuth.instance;
        bool isCreated = false;

        try {
          final cred = await auth.createUserWithEmailAndPassword(
            email: newEmail,
            password: newPassword,
          );

          isCreated = true;

          //Create new user id in users database
          StoreService.instance.addUser(cred.user!.uid);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));
            errorFlag = 1;
          } else if (e.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));
            errorFlag = 2;
          }
        } catch (e) {
          print(e);
          isCreated = false;
        }

        newEmail = '';
        newPassword = '';
        verifyPassword = '';

        if (isCreated) {
          Navigator.pop(context);
        }
      });
    }
  }

  void setNewEmail(String formValue) {
    newEmail = formValue;
  }

  void setNewPassword(String formValue) {
    newPassword = formValue;
  }

  void setVerifyPassword(String formValue) {
    verifyPassword = formValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Flexible(
          flex: 3,
          child: Text('Signup Here',
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
        ),
        Form (
          key: widget._signupFormKey,
          child: 
          Expanded(
            flex: 2,
            child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'New Email',
                ),
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Email empty!';
                  } else {
                    //_submitLogin(value);
                    setNewEmail(value);
                  }
                  return null;
                },
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'New Password',
                ),
                obscureText: true,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Password empty!';
                  } else {
                    //_submitSignup(value);
                    setNewPassword(value);
                  }
                  return null;
                },
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Confirm password empty!';
                  } else {
                    setVerifyPassword(value);
                  }
                  return null;
                },
              ),
            )
          ),
          const SizedBox(height: 60),
          Expanded(
            child: ElevatedButton(
              child: const Text("Sign Up"),
              onPressed: () async {
                if (widget._signupFormKey.currentState!.validate()) {
                 await _submitSignup();
                }
              },
            ),
          ),
          Builder(
            builder: (context) {
              switch (errorFlag) {
                case 1:
                  return Container(child: const Text('The password provided is too weak.'));
                case 2:
                  return Container(child: const Text('The account already exists for that email.'));
                default:
                  return Container();
              }
            }
          )
        ]
      ),),
      ),
      ]
    );
  }
}
