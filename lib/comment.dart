import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forum/addpost.dart';
import 'package:forum/sign-in.dart';
import 'package:forum/add-comment.dart';
import 'package:forum/favorite.dart';


class CommentWidget extends StatefulWidget {
  final Stream<int> stream;
  CommentWidget({this.stream});
  @override
  _CommentWidget createState() => _CommentWidget();
}

class _CommentWidget extends State<CommentWidget> {
  int _commentCount = 0;

  void _updateCount(int newValue) {
    setState(() {
      _commentCount = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.stream.listen((count) {
      _updateCount(count);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Text( // # of comments
      "  $_commentCount",
      style: const TextStyle(
        fontSize: 10.0,
        color: Colors.black,
      ),
    );
  }
}

class PostArguments {
  final Widget thumbnail;
  final String author;
  final String title;
  final String bodyText;
  final DocumentReference post;
  final User curUser;

  PostArguments(this.thumbnail, this.author, this.title, this.bodyText, this.post, this.curUser);
}

