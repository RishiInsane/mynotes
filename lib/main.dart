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
    return Scaffold(
      appBar: AppBar(title: const Text('Home'),),//AppBar
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            //final emailVerified = user?.emailVerified ?? false; //direct boolean comparison for verified-or-not could have been a null comparison therefore we first get it checked and then use it.
            if(user?.emailVerified ?? false){
              print('you are a verified user');
            }else{
              print('you need to verify your email');
            }
              return const Text('Done');
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}