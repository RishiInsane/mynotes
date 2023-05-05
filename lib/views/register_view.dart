import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/utilities/show%20error%20dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //I started here//
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your Email ID'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                ); //creating the user
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(
                    verifyEmailRoute); //pushNamed helps us go back to the original page incase we need it it gives a GoBack arrow
              } on FirebaseAuthException catch (e) {
                // showing errors
                if (e.code == 'weak-password') {
                  await showErrorDialog(context, 'Weak Password');
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(context, 'Email Already In Use');
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(context, 'Invalid Email');
                } else {
                  await showErrorDialog(context, 'Error:${e.code}');
                }
              } catch (e) {
                //showing generic errors
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered?Login here!'),
          ),
        ],
      ),
    );
  }
}
