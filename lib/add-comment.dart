import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forum/addpost.dart';
import 'package:forum/list-post.dart';
import 'package:forum/comment.dart';


class AddComment extends StatelessWidget {
  final commentCntl = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build (BuildContext context) {
    final PostArguments arg = ModalRoute.of(context).settings.arguments;
    return Scaffold (
        appBar: AppBar (
          title: Text('New comment'),
          backgroundColor: Colors.lime,
        ),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: new FutureBuilder  (
              future: getComments(arg.post),
              builder: (BuildContext context, AsyncSnapshot <List<Remarks>> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong: ${snapshot.error}");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  List <Widget> list = [];
                  list.add(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 50.0,
                            child: arg.thumbnail,
                          ),
                          Container(
                            width: 100.0,
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              arg.author,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 10.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text("   ") // fillter
                          ),
                        ],
                      )
                  );
                  list.add(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              arg.title,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                  );
                  list.add(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              arg.bodyText,
                              maxLines: null,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                  );
                  list.add(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextField(
                              maxLines: null,
                              controller: commentCntl,
                              decoration: InputDecoration(
                                labelText: 'Write a comment...',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              var tmp = arg.curUser.email.split("@");
                              var userid = tmp[0] + "@" + tmp[1].split(".")[0];
                              _db.collection("comments").add(
                                  {
                                    "text": commentCntl.text,
                                    "user": userid,
                                  }
                              ).then((c1) {
                                _db.collection("posts").doc(arg.post.id).update({
                                  "remarks": FieldValue.arrayUnion([c1]),
                                  "ncomments": FieldValue.increment(1)});
                              }).then((_) {
                                Navigator.pop(context, true);
                              });
                            },
                            child: Container(
                              width: 100.0,
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Comment",
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  );
                  snapshot.data.forEach((s) {
                    list.add(
                        Row (
                          children: <Widget> [
                            Text("${s.user}: "),
                            Text("${s.text}"),
                          ],
                        )
                    );
                  });
                  return ListView (
                      children: list,
                  );
                }
                return Text("Loading.....");
              },
            ),
        ),
    );
  }

  Future <List<Remarks>> getComments(DocumentReference post) async {
    final db = FirebaseFirestore.instance;
    var result = await db.collection("posts").doc(post.id).get();
    if (result.data()["ncomments"] == 0)
      return [];
    List<dynamic> remarks = List.from(result.data()["remarks"]);
    List <Remarks> list = [];
    await Future.forEach(remarks, (r)  async {
      await db.collection("comments").doc(r.id).get().then((comment) {
        list.add(new Remarks(text: comment['text'], user: comment['user']));
      });
    }).then((_) {
      print(list.length);
      //return list;
    });
    return list;
  }

}

class Remarks {
  final String  text;
  final String user;

  Remarks({this.text, this.user});
}