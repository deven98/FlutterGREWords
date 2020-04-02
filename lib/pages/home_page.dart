import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gre/pages/learn_words_page.dart';
import 'package:flutter_gre/pages/saved_words_page.dart';
import 'package:flutter_gre/data/facts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String fact = "";

  @override
  void initState() {
    super.initState();
    fact = FactData.facts[Random().nextInt(FactData.facts.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Text(
                "Ready to learn?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Did you know?",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child:
                  Text(fact, style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                children: <Widget>[
                  CategoryTitle(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearnWordsPage(),
                        ),
                      );
                    },
                    heroTag: "title1",
                    title: "Learn Words",
                    colorOne: Colors.blue,
                    colorTwo: Colors.green,
                    icon: Icons.chrome_reader_mode,
                  ),
                  CategoryTitle(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SavedWordsPage(),
                        ),
                      );
                    },
                    heroTag: "title2",
                    title: "Saved Words",
                    colorOne: Colors.red,
                    colorTwo: Colors.orange,
                    icon: Icons.save,
                  ),
                  CategoryTitle(
                    onTap: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => SavedWordsPage(),
//                        ),
//                      );
                    },
                    heroTag: "title3",
                    title: "Write Essays",
                    colorOne: Color(0xff56ab2f),
                    colorTwo: Color(0xffa8e063),
                    icon: Icons.edit,
                  ),
                  CategoryTitle(
                    onTap: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => SavedWordsPage(),
//                        ),
//                      );
                    },
                    heroTag: "title4",
                    title: "GRE Info",
                    colorOne: Color(0xffcc2b5e),
                    colorTwo: Color(0xff753a88),
                    icon: Icons.info_outline,
                  ),
                  CategoryTitle(
                    onTap: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => SavedWordsPage(),
//                        ),
//                      );
                    },
                    heroTag: "title5",
                    title: "About App",
                    colorOne: Color(0xff2193b0),
                    colorTwo: Color(0xff6dd5ed),
                    icon: Icons.phone_android,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String heroTag;
  final colorOne;
  final colorTwo;

  const CategoryTitle({Key key, this.icon, this.title, this.onTap, this.heroTag, this.colorOne, this.colorTwo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: <Widget>[
              Center(child: Icon(icon, color: Colors.white, size: 55.0,)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Hero(
                    tag: heroTag,
                    transitionOnUserGestures: true,
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorOne,
              colorTwo,
            ],
            stops: [
              0.0,
              1.0,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
