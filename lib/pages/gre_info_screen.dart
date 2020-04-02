import 'package:flutter/material.dart';

import '../theme_data.dart';

class GreInfoScreen extends StatelessWidget {
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
              "GRE Info",
              style: TextStyle(
                color: CustomThemeData.secondaryColor,
                fontSize: 22.0,
              ),
            ),
          ),
          tag: "title4",
          transitionOnUserGestures: true,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '''The GRE General Test features question types that closely reflect the kind of thinking you'll do in graduate and professional school, including business and law.

Verbal Reasoning — Measures the ability to analyze and draw conclusions from discourse, reason from incomplete data, understand multiple levels of meaning, such as literal, figurative and author’s intent, summarize text, distinguish major from minor points, understand the meanings of words, sentences and entire texts, and understand relationships among words and among concepts. There is an emphasis on complex verbal reasoning skills.
\nQuantitative Reasoning — Measures the ability to understand, interpret and analyze quantitative information, solve problems using mathematical models, and apply the basic concepts of arithmetic, algebra, geometry and data analysis. There is an emphasis on quantitative reasoning skills.
\nAnalytical Writing — Measures critical thinking and analytical writing skills, including the ability to articulate and support complex ideas with relevant reasons and examples, and examine claims and accompanying evidence. There is an emphasis on analytical writing skills.''',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
