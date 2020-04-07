import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gre/data/awa.dart';
import 'package:flutter_gre/models/essay_model.dart';
import 'package:flutter_gre/services/firestore_service.dart';

class EditEssayScreen extends StatefulWidget {
  final EssayModel essayModel;

  const EditEssayScreen({Key key, this.essayModel}) : super(key: key);

  @override
  _EditEssayScreenState createState() => _EditEssayScreenState();
}

class _EditEssayScreenState extends State<EditEssayScreen> {
  bool questionOpened = true;
  bool publicEssay = true;

  TextEditingController _textController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.essayModel.text;
    publicEssay = widget.essayModel.public;
  }

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
                    widget.essayModel.question,
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

                Firestore _db = Firestore.instance;

                _db
                    .collection('essays')
                    .document(widget.essayModel.id)
                    .updateData({
                  "text": _textController.text,
                  "public": publicEssay,
                }).then((value) {
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
                "Update",
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
