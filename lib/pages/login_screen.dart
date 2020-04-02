import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart' hide AppleSignInButton;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_gre/pages/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'email_login_screen.dart';

/// First page to see after splash screen.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildTitle(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Hero(
      tag: "logo",
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              'images/app_logo.png',
              height: 100.0,
              width: 100.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: 240.0,
            child: GoogleSignInButton(
              darkMode: true,
              onPressed: () {
                _handleSignIn().then((user) {
                  if (user != null) {
                    _proceedToMainScreen();
                  }
                });
              },
            ),
          ),
          if (Platform.isIOS)
            SizedBox(
              height: 8.0,
            ),
          if (Platform.isIOS)
            SizedBox(
              width: 240.0,
              child: AppleSignInButton(
                onPressed: () {
                  _signInWithApple();
                },
              ),
            ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            width: 240.0,
            child: FlatButton(
              color: Colors.white,
              onPressed: () {
                _signInWithEmail();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sign in with Email",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            width: 240.0,
            child: FlatButton(
              color: Colors.white,
              onPressed: () {
                _signInAnonymously();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Anonymous Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToMainScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _signInWithEmail() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmailLoginScreen()));
  }

  void _signInWithApple() async {
    try {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            print("successful sign in");
            final AppleIdCredential appleIdCredential = result.credential;

            OAuthProvider oAuthProvider =
                new OAuthProvider(providerId: "apple.com");
            final AuthCredential credential = oAuthProvider.getCredential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            final AuthResult _res =
                await FirebaseAuth.instance.signInWithCredential(credential);

            FirebaseAuth.instance.currentUser().then((val) async {
              UserUpdateInfo updateUser = UserUpdateInfo();
              updateUser.displayName =
                  "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";
              updateUser.photoUrl = "define an url";
              await val.updateProfile(updateUser);

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            });
          } catch (e) {
            print(e);
          }
          break;
        case AuthorizationStatus.error:
          print("Error");
          break;

        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    } catch (error) {
      print("error with apple sign in");
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var signInResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = signInResult.user;
    print("signed in " + user.displayName);
    return user;
  }

  void _signInAnonymously() {
    _auth.signInAnonymously().then((value) {
      if (value.user != null) {
        _proceedToMainScreen();
      }
    });
  }
}
