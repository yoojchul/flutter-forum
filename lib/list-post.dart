import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forum/favorite.dart';
import 'package:forum/comment.dart';
import 'package:forum/list-item.dart';

class ListPost extends StatelessWidget {
  int _tabInd = 0;

  @override
  Widget build(BuildContext context) {
    final Moving arg = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      initialIndex: arg.tabInd,
      length: 3,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Forum sample"),
          backgroundColor: Colors.lime,
          bottom: new TabBar(
            onTap: (index) {
              _tabInd = index;
            },
            tabs: <Tab>[
              Tab (text: "Recent"),
              Tab (text: "My Posts"),
              Tab (text: "My Top posts"),
              //new Tab(icon: new Icon(Icons.arrow_forward)),
              //new Tab(icon: new Icon(Icons.arrow_downward)),
              //new Tab(icon: new Icon(Icons.arrow_back)),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Page1(curUser: arg.user),
            new Page2(curUser: arg.user),
            new Page3(curUser: arg.user),
          ],
        ),
        floatingActionButton: FloatingActionButton (
          tooltip: 'New Post',
          onPressed: () {
            print("Pressed");
            Navigator.pushNamed(context, '/new-post',
                arguments: Moving(user: arg.user, tabInd: _tabInd));
          },
          child: Icon(Icons.create),
        ),
      ),
    );
  }
}

class Moving {
  final User user;
  final int tabInd;
  Moving({this.user, this.tabInd});
}

class Page1 extends StatelessWidget {
  final User curUser;

  Page1({this.curUser});

  @override
  Widget build(BuildContext context)  {
    return new FutureBuilder(
        future: getPost(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            List <Widget> list = [];
            snapshot.data.docs.forEach((r) {
              list.add(_buildWidget(r, curUser));
            });
            return Row(
              children: [
                Expanded(
                  child: ListView(
                      children: list
                  ),
                ),
              ],
            );
          }
          return Text ("Loading...");
        });
  }

  Future <QuerySnapshot> getPost () async {
    final db = FirebaseFirestore.instance;
    var result = await db.collection("posts").orderBy("timestamp", descending: true).get();
    return result;
  }

  Widget _buildWidget(DocumentSnapshot doc, User curUser) {
    return Column (
      children : <Widget> [
        CustomListItem (
          thumbnail: Container(
            child: Icon(
              Icons.account_box,
              size: 50.0,
            ),
          ),
          title: doc['title'],
          author: doc['user'],
          bodyText: doc['body'],
          ncomments: doc['ncomments'],
          post: doc,
          curUser: curUser,
        ),
        Divider(
        thickness:5,
        indent: 20,
        endIndent:20,
        ),
      ],
    );
  }
}

class Page2 extends StatelessWidget {
  final User curUser;

  Page2({this.curUser});

  @override
  Widget build(BuildContext context)  {
    return new FutureBuilder(
        future: getMyPost(curUser),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            List <Widget> list = [];
            snapshot.data.docs.forEach((r) {
              list.add(_buildWidget(r, curUser));
            });
            return Row(
              children: [
                Expanded(
                  child: ListView(
                      children: list
                  ),
                ),
              ],
            );
          }
          return Text ("Loading...");
        });
  }

  Future <QuerySnapshot> getMyPost (User arg) async {
    final db = FirebaseFirestore.instance;
    var tmp = arg.email.split("@");
    var userid = tmp[0] + "@" + tmp[1].split(".")[0]; // id@google
    var result = await
    db.collection("posts").where("user", isEqualTo: userid).orderBy("timestamp",descending: true).get();
    return result;
  }

  Widget _buildWidget(DocumentSnapshot doc, User curUser) {
    return Column (
      children : <Widget> [
        CustomListItem (
          thumbnail: Container(
            child: Icon(
              Icons.account_box,
              size: 50.0,
            ),
          ),
          title: doc['title'],
          author: doc['user'],
          bodyText: doc['body'],
          ncomments: doc['ncomments'],
          post: doc,
          curUser: curUser,
        ),
        Divider(
          thickness:5,
          indent: 20,
          endIndent:20,
        ),
      ],
    );
  }
}

/*
class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
        child: new Icon(
          Icons.sentiment_very_dissatisfied, size: 200, color: Colors.black, ),
      ),
    );
  }
}
*/

class Page3 extends StatelessWidget {
  final User curUser;

  Page3({this.curUser});

  @override
  Widget build(BuildContext context)  {
    return new FutureBuilder(
        future: getMyTopPost(curUser),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            List <Widget> list = [];
            snapshot.data.docs.forEach((r) {
                list.add(_buildWidget(r, curUser));
            });
            return Row(
              children: [
                Expanded(
                  child: ListView(
                      children: list
                  ),
                ),
              ],
            );
          }
          return Text ("Loading...");
        });
  }

  Future <QuerySnapshot> getMyTopPost (User arg) async {
    final db = FirebaseFirestore.instance;
    var tmp = arg.email.split("@");
    var username = tmp[0] + "@" + tmp[1].split(".")[0]; // id@google

    var result = await
    db.collection("posts").where("user", isEqualTo: username)
        .orderBy("likes", descending: true).orderBy("timestamp",descending: true)
        .get();
    return result;
  }

  Widget _buildWidget(DocumentSnapshot doc, User curUser) {
    return Column (
      children : <Widget> [
        CustomListItem (
          thumbnail: Container(
            child: Icon(
              Icons.account_box,
              size: 50.0,
            ),
          ),
          title: doc['title'],
          author: doc['user'],
          bodyText: doc['body'],
          ncomments: doc['ncomments'],
          post: doc,
          curUser: curUser,
        ),
        Divider(
          thickness:5,
          indent: 20,
          endIndent:20,
        ),
      ],
    );
  }
}