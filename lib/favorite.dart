import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forum/addpost.dart';
import 'package:forum/sign-in.dart';
import 'package:forum/add-comment.dart';


class FavoriteWidget extends StatefulWidget {
  DocumentSnapshot post;
  FavoriteWidget ({this.post});
  //final count = this.post['likes'];
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  int _favoriteCount;
  @override
  initState() {
    _favoriteCount = widget.post['likes'];
  }

  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell (
          onTap: () {
            _increaseFavorite();
          },
          child: Container(
            width: 30.0,
            alignment: Alignment.bottomRight,
            child: Icon (
              Icons.thumb_up,
            ),
          ),
        ),
        Container(
          width: 20.0,
          alignment: Alignment.bottomLeft,
          child: Text(
            '  $_favoriteCount',
          ),
        ),
      ],
    );
  }

  void _increaseFavorite() {
    setState(() {
      _favoriteCount += 1;
      widget.post.reference.update({"likes": FieldValue.increment(1)});
    });
  }
}
