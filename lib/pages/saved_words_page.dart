import 'package:flutter/material.dart';
import 'package:flutter_gre/data/word.dart';
import 'package:flutter_gre/data/words.dart';
import 'package:flutter_gre/sqlite/db_provider.dart';
import 'package:flutter_gre/theme_data.dart';

class SavedWordsPage extends StatefulWidget {
  @override
  _SavedWordsPageState createState() => _SavedWordsPageState();
}

class _SavedWordsPageState extends State<SavedWordsPage> {
  List<Word> words;

  var gradients = [
    LinearGradient(
      colors: [
        Colors.blue,
        Colors.green,
      ],
      stops: [
        0.3,
        0.7,
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    LinearGradient(
      colors: [
        Colors.red,
        Colors.orange,
      ],
      stops: [
        0.3,
        0.7,
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    LinearGradient(
      colors: [
        Colors.deepPurple,
        Colors.deepPurpleAccent,
      ],
      stops: [
        0.3,
        0.7,
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    LinearGradient(
      colors: [
        Colors.teal,
        Colors.cyan,
      ],
      stops: [
        0.3,
        0.7,
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.deepPurple,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Hero(
          child: Material(
            color: Colors.transparent,
            child: Text(
              "Saved Words",
              style: TextStyle(
                color: CustomThemeData.secondaryColor,
                fontSize: 22.0,
              ),
            ),
          ),
          tag: "title2",
          transitionOnUserGestures: true,
        ),
      ),
      body: words == null
          ? CircularProgressIndicator()
          : (words.isEmpty
              ? Center(
                  child: Text(
                    "It's quite lonely here...",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : _buildPage()),
    );
  }

  Widget _buildPage() {
    return PageView.builder(
      itemBuilder: (context, position) {
        return Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  words[position].wordTitle,
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  words[position].wordDefinition,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            gradient: gradients[position % gradients.length],
          ),
        );
      },
      scrollDirection: Axis.vertical,
      itemCount: words.length,
    );
  }

  void _loadWords() async {
    words = await DBProvider.db.getAllWords();
    setState(() {});
  }
}
