import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme_data.dart';

class AboutAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.deepPurple,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Hero(
          child: Material(
            color: Colors.transparent,
            child: Text(
              "About App",
              style: TextStyle(
                color: CustomThemeData.secondaryColor,
                fontSize: 22.0,
              ),
            ),
          ),
          tag: "title5",
          transitionOnUserGestures: true,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "GRE One helps you maximise your potential on test day preparing you for vocabulary as well as essays. \n\nFree to use, open source.",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                Share.share(
                    "Maximise your GRE potential with GRE ONE: https://play.google.com/store/apps/details?id=n.dev.fluttergre");
              },
              child: Text(
                "Share App",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Created by Deven Joshi",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                _launchURL("https://twitter.com/DevenJoshi7");
              },
              child: Text(
                "Twitter",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                _launchURL("https://www.github.com/deven98");
              },
              child: Text(
                "GitHub",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
