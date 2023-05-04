import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/register_view.dart';

import 'firebase_options.dart';
void main()
{
  WidgetsFlutterBinding.ensureInitialized();  //initialising firebase.initializeApp
  runApp(MaterialApp
    (
      title: 'Flutter Demo',
      theme: ThemeData
        (
          primarySwatch: Colors.blue,
        ),
      home: const HomePage(),
      routes: {
        '/login/':(context) => const LoginView(),
        '/register/':(context) => const RegisterView(),
      },
    ),
  );
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //I started here//
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done: // initialization complete
            // final user = FirebaseAuth.instance.currentUser;//to get user
            // //final emailVerified = user?.emailVerified ?? false; //direct boolean comparison for verified-or-not could have been a null comparison therefore we first get it checked and then use it.
            // if(user?.emailVerified ?? false){
            //   return const Text('Done');
            // }else{
            //   return const VerifyEmailView();

            //   //pushing a widget on the screen(anonymous route)
            //  /*Navigator.of(context).push(  //creating a navigator of the context and the pushing a widget so we create a widget MaterialPageRoute and then push it
            //   MaterialPageRoute(
            //     builder: (context) => const VerifyEmailView()
            //     )
            //     );//pushing complete
            //     */

            // }
            return const LoginView();
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}
class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Column(children: [
        const Text('Please verify your email'),
        TextButton(
          onPressed: ()async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text('Send email verification')
          ,)
      ],),
    );
  }
}