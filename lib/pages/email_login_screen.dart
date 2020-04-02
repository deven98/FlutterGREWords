import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gre/pages/home_page.dart';
import 'package:flutter_gre/pages/reset_password_screen.dart';
import 'package:flutter_gre/pages/verify_email_screen.dart';
import 'package:regexed_validator/regexed_validator.dart';

class EmailLoginScreen extends StatefulWidget {
  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen>
    with SingleTickerProviderStateMixin {
  bool isPasswordObscured = true;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Email Sign-In"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("I want to: "),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).accentColor),
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16.0)),
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: _tabController.index == 1
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ],
                  controller: _tabController,
                  indicator: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16.0)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Enter your email"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "john.doe@xyz.com"),
                controller: _usernameController,
                validator: (val) {
                  if (!validator.email(val)) {
                    return "Email not valid";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Password"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "*********",
                    suffixIcon: IconButton(
                        icon: Icon(isPasswordObscured
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isPasswordObscured = !isPasswordObscured;
                          });
                        })),
                validator: (val) {
                  if (_passwordController.text.length < 6) {
                    return "Not enough charac";
                  }
                  return null;
                },
                obscureText: isPasswordObscured,
                controller: _passwordController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    String username = _usernameController.text.trim();
                    String password = _passwordController.text.trim();

                    if (_tabController.index == 1) {
                      _signInWithEmail(username, password);
                    } else {
                      _signUpWithEmail(username, password);
                    }
                  }
                },
                child: Text(
                  _tabController.index == 0 ? "Sign Up" : "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.all(16.0),
                color: Theme.of(context).primaryColor,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen()));
                  },
                ),
              ),
            )
          ],
        ),
        autovalidate: true,
      ),
    );
  }

  void _signInWithEmail(String username, String password) {
    _auth.signInWithEmailAndPassword(email: username, password: password).then(
        (result) {
      if (result.user == null) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Sign-in failed")));
      } else {
        if (result.user.isEmailVerified)
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        else
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyEmailScreen(
                        user: result.user,
                      )),
              (r) => false);
      }
    }, onError: (err) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Sign-in failed")));
    });
  }

  void _signUpWithEmail(String username, String password) {
    _auth
        .createUserWithEmailAndPassword(email: username, password: password)
        .then((result) {
      print(result.toString());
      if (result.user == null) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Sign-in failed")));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyEmailScreen(
                      user: result.user,
                    )),
            (r) => false);
      }
    }, onError: (err) {
      print(err);
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Sign-in failed: ${err.message}")));
    });
  }
}
