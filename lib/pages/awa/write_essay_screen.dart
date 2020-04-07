import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gre/data/awa.dart';
import 'package:flutter_gre/services/firestore_service.dart';

class WriteEssayScreen extends StatefulWidget {
  final Essay essay;

  const WriteEssayScreen({Key key, this.essay}) : super(key: key);

  @override
  _WriteEssayScreenState createState() => _WriteEssayScreenState();
}

class _WriteEssayScreenState extends State<WriteEssayScreen> {
  bool questionOpened = true;
  bool publicEssay = true;

  TextEditingController _textController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: <Widget>[
          SafeArea(
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Expanded(
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(-24.0, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Write",
                          style: TextStyle(color: Colors.white, fontSize: 26.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(
                "Question",
                style: questionOpened
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.essay.question,
                  ),
                ),
              ],
              backgroundColor: Colors.white,
              onExpansionChanged: (val) {
                setState(() {
                  questionOpened = val;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                hintText:
                    "Write an essay / outline for the above question. Save this once done to compare your essays later. You can also choose to make the essay public.",
                hintMaxLines: 6,
              ),
              minLines: 6,
              maxLines: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              child: CheckboxListTile(
                value: publicEssay,
                onChanged: (val) {
                  setState(() {
                    publicEssay = val;
                  });
                },
                title: Text("Make essay visible to other users"),
                subtitle: Text("Coming Soon"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () async {
                _scaffoldKey.currentState
                    .showSnackBar(SnackBar(content: Text("Uploading...")));

                FirebaseUser user = await FirebaseAuth.instance.currentUser();

                _firestoreService
                    .uploadEssay(
                  widget.essay.question,
                  widget.essay.type == EssayType.issue ? "Issue" : "Argument",
                  _textController.text,
                  publicEssay,
                  user.uid,
                )
                    .then((value) {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState
                      .showSnackBar(SnackBar(content: Text("Success")));
                  Future.delayed(Duration(seconds: 1)).then((value) {
                    Navigator.pop(context);
                  });
                }).catchError((err) {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Something went wrong")));
                });
              },
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
            ),
          )
        ],
      ),
    );
  }
}
