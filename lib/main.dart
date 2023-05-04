import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';
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
            final user = FirebaseAuth.instance.currentUser;//to get user
            if(user != null){
              if(user.emailVerified){
                print('email is verified');
              }else{
                return const VerifyEmailView();
              }
            }else{
              return const LoginView();
            }
            return const Text('Done');
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}
