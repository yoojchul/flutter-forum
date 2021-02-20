import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forum/favorite.dart';
import 'package:forum/comment.dart';


class CustomListItem extends StatelessWidget {
  CustomListItem({
    this.thumbnail,
    this.title,
    this.author,
    this.bodyText,
    this.ncomments,
    this.post,
    this.curUser,
  });

  final Widget thumbnail;
  final String title;
  final String bodyText;
  final String author;
  final int ncomments;
  final DocumentSnapshot post;
  final User curUser;

  StreamController<int> _controller = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    _controller.add(post['ncomments']);
    return Padding(
      //padding: const EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container (
                width: 50.0,
                child: thumbnail,
              ),
              Container (
                width: 100.0,
                alignment: Alignment.bottomLeft,
                child: Text(
                  author,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Text("   ") //filler
              ),
              Row (
                children: <Widget> [
                  Container (
                    width: 60.0,
                    alignment: Alignment.bottomRight,
                    child: Text (
                      "comments: ",
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container (
                    width: 20.0,  // no of comments
                    alignment: Alignment.bottomLeft,
                    child: CommentWidget(stream: _controller.stream),
                  ),
                  Container (
                    width: 50.0,
                    child: FavoriteWidget(post: post),
                  ),
                ],
              ),
            ],
          ),
          Row (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: GestureDetector (
                      onTap: () async {
                        await Navigator.pushNamed(context, '/new-comment',
                            arguments: PostArguments(
                                thumbnail, author, title, bodyText, post.reference, curUser)).then((result) {
                          if (result == null) {
                            print("Back button pressed");
                          }
                          else {
                            print("pop from AddComment ");
                            //print(post['ncomments']);
                            _controller.add(post['ncomments']+1);
                          }
                        });
                      },
                      child: Text(
                        title,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ),
              ]
          ),
          Row (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector (
                  onTap: () async {
                    await Navigator.pushNamed(
                        context, '/new-comment',
                        arguments: PostArguments(
                            thumbnail, author, title, bodyText, post.reference, curUser)).then((result) {
                      if (result == null) {
                        print("Back button pressed");
                      }
                      else {
                        print("pop from AddComment with comments: ");
                        //print(post['ncomments']);
                        _controller.add(post['ncomments'] + 1);
                      }
                    });
                  },
                  child: Text(
                    bodyText,
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
