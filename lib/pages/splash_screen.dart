import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gre/pages/home_page.dart';
import 'package:flutter_gre/pages/verify_email_screen.dart';

import 'login_screen.dart';

/// Splash screen
/// TODO: Move splash screen to Android side to initialise before Flutter app starts
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((val) async {
      FirebaseAuth _auth = FirebaseAuth.instance;

      var user = await _auth.currentUser();

      if (user != null) {
        if (user.isEmailVerified || user.isAnonymous)
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        else
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyEmailScreen(
                        user: user,
                      )));
      } else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Hero(
          tag: "logo",
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
      ),
    );
  }
}
