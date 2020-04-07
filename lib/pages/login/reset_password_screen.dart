import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:regexed_validator/regexed_validator.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset password screen"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text("Enter your email"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "john.doe@abc.com"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                String email = _emailController.text.trim();

                if (validator.email(email)) {
                  _auth.sendPasswordResetEmail(email: email).then((val) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Password reset link sent. Please check your email.")));
                  }, onError: (err) {
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text("Failed: ${err.message}")));
                  }).catchError((error) {
                    print(error);
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text("Error")));
                  }).timeout(Duration(seconds: 5), onTimeout: () {
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text("Timeout")));
                  });
                } else {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Not an email address")));
                }
              },
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(16.0),
            ),
          )
        ],
      ),
    );
  }
}
