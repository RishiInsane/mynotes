import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;
void main()
{
  WidgetsFlutterBinding.ensureInitialized();  //initialising firebase.initializeApp
  runApp(MaterialApp
    (
      title: 'Flutter Demo',
      theme: ThemeData
        (
          primarySwatch: Colors.cyan,
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
                return const NotesView();
              }else{
                return const VerifyEmailView();
              }
            }else{
              return const LoginView();
            }
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}
enum MenuAction{logout}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [PopupMenuButton<MenuAction>(
          onSelected:(value) async{
            switch(value){
              case MenuAction.logout:
                final shouldLogut = await showLogOutDialog(context);
                if(shouldLogut){
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false);
                }
                break;
            }
        },itemBuilder: (context) {
          return const [
            PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text('Logout'),
              )
          ];
        },)],
      ),
      body: const Text('Hello World'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
    context: context,
    builder:(context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {Navigator.of(context).pop(false);},//pops the alert dialog box based on the value of true/false
            child: const Text('Cancel')),
            TextButton(
            onPressed: () {Navigator.of(context).pop(true);},
            child: const Text('Logout')),
        ],
      );
    },).then((value) => value ?? false); //if the dialog gets dismissed the future function gets completed without getting any value then the .then() function helps us to either get some value or is false by default 
}