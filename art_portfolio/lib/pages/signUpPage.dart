import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/styling.dart';
import '../database/galleryStoreService.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: const Text("Sign Up", style: AppTextStyles.headline1),
                           backgroundColor: AppColors.appBarColor),
            resizeToAvoidBottomInset: false,
            body: SignupBody());
  }
}

class SignupBody extends StatefulWidget {
  const SignupBody({super.key});

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  final _signupFormKey = GlobalKey<FormState>();

  String newEmail = '';
  String newUser = '';
  String newPassword = '';
  String verifyPassword = '';
  int errorFlag = 0;

  Future<void> _submitSignup() async {
    if ((_signupFormKey.currentState!.validate())) {
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
            await GalleryStoreService.instance.addUser(cred.user!.uid, newUser);
            
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              if(context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));
              }
              errorFlag = 1;
            } else if (e.code == 'email-already-in-use') {
              if(context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));
              }
              errorFlag = 2;
            }
          } catch (e) {
            print(e);
            isCreated = false;
          }

          newEmail = '';
          newUser = '';
          newPassword = '';
          verifyPassword = '';

          if (isCreated) {
            if(context.mounted) {
              Navigator.pop(context);
            }
          }
        });
      }
    }
  }

  void setNewEmail(String formValue) {
    newEmail = formValue;
  }

  void setNewUser(String formValue) {
    newUser = formValue;
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
          flex: 2,
          child: Text('Signup Here',
                      style: AppTextStyles.headline2
                    ),
        ),
        const SizedBox(height: 30),
        Expanded(
          flex: 3,
          child: Card(
            color: AppColors.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Form (
          key: _signupFormKey,
          child: 
          Expanded(
            flex: 2,
            child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'New Email',
                ),
                validator: (value) {
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
          const SizedBox(height: 30),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'New User',
                ),
                obscureText: true,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'User empty!';
                  } else {
                    //_submitSignup(value);
                    setNewUser(value);
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
          const SizedBox(height: 30),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
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
          const SizedBox(height: 30),
          Expanded(
            child: ElevatedButton(
              style: AppButtonStyles.primaryButton,
              onPressed: () async {
                await _submitSignup();
              },
              child: const Text("Sign Up"),
            ),
          ),
        ]
      ),),
      ),),),),
      ]
    );
  }
}
