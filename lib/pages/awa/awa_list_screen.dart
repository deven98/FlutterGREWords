import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gre/data/awa.dart';
import 'package:flutter_gre/models/essay_model.dart';
import 'package:flutter_gre/pages/awa/edit_essay_screen.dart';
import 'package:flutter_gre/pages/awa/write_essay_screen.dart';
import 'package:flutter_gre/services/firestore_service.dart';

import '../../theme_data.dart';

class AwaListScreen extends StatefulWidget {
  @override
  _AwaListScreenState createState() => _AwaListScreenState();
}

class _AwaListScreenState extends State<AwaListScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  FirebaseUser _user;

  var months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  void _getUser() async {
    _user = await FirebaseAuth.instance.currentUser();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
              "AWA Pool",
              style: TextStyle(
                color: CustomThemeData.secondaryColor,
                fontSize: 22.0,
              ),
            ),
          ),
          tag: "title3",
          transitionOnUserGestures: true,
        ),
        bottom: TabBar(
          tabs: [
            Tab(
              child: Text(
                "Issue",
                style: TextStyle(
                    color: _tabController.index == 0
                        ? Colors.white
                        : Theme.of(context).primaryColor),
              ),
            ),
            Tab(
              child: Text(
                "Argument",
                style: TextStyle(
                    color: _tabController.index == 1
                        ? Colors.white
                        : Theme.of(context).primaryColor),
              ),
            ),
            Tab(
              child: Text(
                "My Essays",
                style: TextStyle(
                    color: _tabController.index == 2
                        ? Colors.white
                        : Theme.of(context).primaryColor),
              ),
            )
          ],
          indicatorColor: CustomThemeData.secondaryColor,
          indicator: CustomTabIndicator(),
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildIssueSection(),
          _buildArgumentSection(),
          _buildSavedSection(),
        ],
      ),
    );
  }

  Widget _buildIssueSection() {
    var data =
        essayData.where((element) => element.type == EssayType.issue).toList();

    return ListView.builder(
      itemBuilder: (context, position) {
        return EssayCard(
          index: position,
          title: data[position].question,
          description: "Issue",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WriteEssayScreen(
                      essay: data[position],
                    )));
          },
        );
      },
      itemCount: data.length,
    );
  }

  Widget _buildArgumentSection() {
    var data = essayData
        .where((element) => element.type == EssayType.argument)
        .toList();

    return ListView.builder(
      itemBuilder: (context, position) {
        return EssayCard(
          index: position,
          title: data[position].question,
          description: "Argument",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WriteEssayScreen(
                      essay: data[position],
                    )));
          },
        );
      },
      itemCount: data.length,
    );
  }

  Widget _buildSavedSection() {
    if (_user == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }

    return FutureBuilder<List<EssayModel>>(
        future: FirestoreService().getUserEssays(_user.uid),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          }

          return ListView.builder(
            itemBuilder: (context, position) {
              var dateTime = DateTime.fromMillisecondsSinceEpoch(
                  snapshot.data[position].timestamp);
              return EssayCard(
                index: position,
                title: snapshot.data[position].question,
                description:
                    dateTime.day.toString() + " " + months[dateTime.month - 1],
                maxLines: 4,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditEssayScreen(
                            essayModel: snapshot.data[position],
                          )));
                },
              );
            },
            itemCount: snapshot.data.length,
          );
        });
  }
}

class EssayCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String description;
  final int index;
  final int maxLines;

  const EssayCard(
      {Key key,
      this.onTap,
      this.index,
      this.title,
      this.description,
      this.maxLines = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0,
        child: ListTile(
          onTap: onTap,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  _CustomPainter createBoxPainter([VoidCallback onChanged]) {
    return new _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    final Rect rect = offset & configuration.size;
    final Paint paint = Paint();
    paint.color = Colors.deepPurple;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(0.0)), paint);
  }
}
