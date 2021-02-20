import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forum/list-post.dart';
import 'package:forum/sign-in.dart';


//SignInPageState pageState;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _mailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();
  bool doRemember = false;
  String _messageKept = "";
  User _user;
  final FirebaseAuth fAuth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getRememberInfo();
  }

  @override
  void dispose() {
    setRememberInfo();
    _mailCon.dispose();
    _pwCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if (_user != null) Navigator.pushNamed(context, "/list-post", arguments: _user);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text("Sign-In Page"),
          backgroundColor: Colors.lime,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              children: <Widget>[
                //Header
                Container(
                  height: 50,
                  decoration: BoxDecoration(color: Colors.amber),
                  child: Center(
                    child: Text(
                      "Sign In to Your Account",
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Input Area
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 1),
                  ),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _mailCon,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: "Email",
                        ),
                      ),
                      TextField(
                        controller: _pwCon,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Password",
                        ),
                        obscureText: true,
                      ),
                    ].map((c) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: c,
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          // Remember Me
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: doRemember,
                  onChanged: (newValue) {
                    setState(() {
                      doRemember = newValue;
                    });
                  },
                ),
                Text("Remember Me")
              ],
            ),
          ),

          // Alert Box
          (_user != null && _user.emailVerified == false)  // isEmailVerified in old
              ? Container(
            margin:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(color: Colors.red[300]),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Mail authentication did not complete."
                        "\nPlease check your verification email.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  color: Colors.lightBlue[400],
                  textColor: Colors.white,
                  child: Text("Resend Verify Email"),
                  onPressed: () {
                    FocusScope.of(context)
                        .requestFocus(new FocusNode()); // hide keyboard
                    _user.sendEmailVerification();
                  },
                )
              ],
            ),
          )
              : Container(),

          // Sign In Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RaisedButton(
              color: Colors.indigo[300],
              child: Text(
                "SIGN IN",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode()); // hide keyboard
                _signIn();
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Need an account?",
                    style: TextStyle(color: Colors.blueGrey)),
                FlatButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-up');
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _signIn() async {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   Signing-In...")
          ],
        ),
      ));
    var ret = false;
    try {
      var result = await fAuth.signInWithEmailAndPassword(
          email: _mailCon.text.trim(), password: _pwCon.text);
      if (result != null)
        _user = result.user; // UserCredential
      //print(_user.uid);
      ret = true;
    } on Exception catch (e) {
      _messageKept = e.toString();
    }
    _scaffoldKey.currentState.hideCurrentSnackBar();
    if (ret == false)
      showMessage();
    else
      Navigator.pushNamed(
          context, "/list-post", arguments: Moving(user: _user, tabInd: 0));
  }

  getRememberInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool("doRemember") ?? false);
    });
    if (doRemember) {
      setState(() {
        _mailCon.text = (prefs.getString("userEmail") ?? "");
        _pwCon.text = (prefs.getString("userPasswd") ?? "");
      });
    }
  }

  setRememberInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("doRemember", doRemember);
    if (doRemember) {
      prefs.setString("userEmail", _mailCon.text);
      prefs.setString("userPasswd", _pwCon.text);
    }
  }

  showMessage() {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 10),
        content: Text(_messageKept),
        action: SnackBarAction(
          label: "Done",
          textColor: Colors.white,
          onPressed: () {},
        ),
      ));
  }
}
