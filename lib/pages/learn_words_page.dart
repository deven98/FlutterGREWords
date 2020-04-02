import 'package:flutter/material.dart';
import 'package:flutter_gre/data/word.dart';
import 'package:flutter_gre/data/words.dart';
import 'package:flutter_gre/theme_data.dart';
import 'package:flutter_gre/sqlite/db_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LearnWordsPage extends StatefulWidget {
  @override
  _LearnWordsPageState createState() => _LearnWordsPageState();
}

class _LearnWordsPageState extends State<LearnWordsPage> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  FlutterTts flutterTts = FlutterTts();

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
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
              "Learn New Words",
              style: TextStyle(
                color: CustomThemeData.secondaryColor,
                fontSize: 22.0,
              ),
            ),
          ),
          tag: "title1",
          transitionOnUserGestures: true,
        ),
      ),
      body: PageView.builder(
        itemBuilder: (context, position) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              WordData.greData[position].wordTitle,
                              style: TextStyle(color: Colors.white, fontSize: 30.0),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _speakWord(WordData.greData[position].wordTitle);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.volume_up, color: Colors.white,),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        WordData.greData[position].wordDefinition,
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: gradients[position % gradients.length],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    splashColor: Colors.white,
                    onTap: () {
                      _addWord(
                        Word(WordData.greData[position].wordTitle,
                            WordData.greData[position].wordDefinition),
                      );
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Word Added!")));
                    },
                    child: Icon(
                      Icons.file_download,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ),
              )
            ],
          );
        },
        scrollDirection: Axis.vertical,
        itemCount: WordData.greData.length,
      ),
    );
  }

  void _addWord(Word word) {
    DBProvider.db.insertWord(word);
  }

  void _speakWord(String word) async {
    await flutterTts.speak(word);
  }
}
