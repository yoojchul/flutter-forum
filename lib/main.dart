import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forum/addpost.dart';
import 'package:forum/list-post.dart';
import 'package:forum/sign-in.dart';
import 'package:forum/sign-up.dart';
import 'package:forum/add-comment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget  {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      title: 'Forum',
      home: SignInPage(),
      routes: {
        '/sign-in' : (context) => SignInPage(),
        '/sign-up' : (context) => SignUpPage(),
        '/list-post': (context) => ListPost(),
        '/new-post' : (context) => AddPost(),
        '/new-comment': (context) => AddComment(),
      },
    );
  }
}
