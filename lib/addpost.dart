import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forum/sign-in.dart';
import 'package:forum/list-post.dart';

class AddPost extends StatelessWidget {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build (BuildContext context)  {
    final Moving arg = ModalRoute.of(context).settings.arguments;
    var tmp = arg.user.email.split("@");
    var userid = tmp[0] + "@" + tmp[1].split(".")[0]; // id@google
    return Scaffold (
      appBar: AppBar (
        title : Text('New Post'),
        backgroundColor: Colors.lime,
      ),
      body: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          Container(
            margin: EdgeInsets.all(8),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            )
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: TextField(
              maxLines: null,
              controller: bodyController,
              decoration: InputDecoration(
                labelText: 'Write your post...',
              ),
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton (
          child: Icon(Icons.check),
          onPressed: () {
            _db.collection("posts").add(
            {
              "title" : titleController.text,
              "body" : bodyController.text,
              "user" : userid,
              "timestamp": FieldValue.serverTimestamp(),
              "ncomments" : 0,
              "likes": 0,
            }
            ).then((_) {
              print("added");
            });
            //_db.collection("posts").snapshots(includeMetadataChanges: true);
            Navigator.pushNamed(context, "/list-post", arguments: arg);
          }
      ),
    );
  }
}