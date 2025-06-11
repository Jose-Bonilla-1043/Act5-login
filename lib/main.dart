import 'package:flutter/material.dart';
import 'package:myapp/notes.dart';
import 'package:firebase_core/firebase_core.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCRSvycH6g9ghY6u_NpWSMxpWgVibOyrX8", 
      appId: "1:694605970681:android:4a3a297d9fc13155af7628", 
      messagingSenderId: "694605970681", 
      projectId: "notesapp-c9fa3")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: NoteScreen());
  }
}