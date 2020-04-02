import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gre/pages/home_page.dart';

import 'login_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final FirebaseUser user;

  const VerifyEmailScreen({Key key, this.user}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.user.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Verify Email"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                "We've sent you an email verification link on ${widget.user.email}. Please verify your account and hit refresh."),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () async {
                var user = await _auth.currentUser();

                await user.reload();

                user = await _auth.currentUser();

                if (user.isEmailVerified) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Email not verified")));
                }
              },
              child: Text(
                "Refresh",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerifyEmailScreen(
                              user: widget.user,
                            )),
                    (r) => false);
              },
              child: Text(
                "Resend verification mail",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (r) => false);
                });
              },
              child: Text(
                "Log out",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }
}
