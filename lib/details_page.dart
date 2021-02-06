import 'package:flutter/material.dart';

Widget detailsPage(Map<String, dynamic> details, int num) {
  return Scaffold(
    appBar: AppBar(
      title: Text(details['name']),
    ),
    body: PageTwo(details, num),
    backgroundColor: Colors.amber,
  );
}

class PageTwo extends StatelessWidget {
  final Map<String, dynamic> details;
  final int num;

  const PageTwo(this.details, this.num);

  @override
  Widget build(BuildContext context) {
    var m = details['matches'][num];
    var insets = EdgeInsets.all(15.0);
    var extensionStr = m['score1et'] != null
        ? "Extension: ${m['score1et']} : ${m['score2et']}"
        : "No Extension";
    var s1 = m['score1'] ?? "?";
    var s2 = m['score2'] ?? "?";
    var goals = <Widget>[];
    if (m['goals1'] != null) {
      for (var goal in m['goals1']) {
        goals.add(Row(
          children: <Widget>[
            Expanded(child: Text("${goal['name']}"), flex: 2),
            Expanded(child: Text("Minute ${goal['minute']}"), flex: 2),
            Expanded(child: Text("${goal['score1']} : "), flex: 1),
            Expanded(child: Text("${goal['score2']}"), flex: 1),
          ],
        ));
      }
    }
    if (m['goals2'] != null) {
      if (m['goals1'] != null &&
          m['goals1'].length > 0 &&
          m['goals2'].length > 0) {
        print(m['goals2'].length);
        goals.add(Divider());
      }
      for (var goal in m['goals2']) {
        goals.add(Row(
          children: <Widget>[
            Expanded(child: Text("${goal['name']}"), flex: 2),
            Expanded(child: Text("Minute ${goal['minute']}"), flex: 2),
            Expanded(child: Text("${goal['score1']} : "), flex: 1),
            Expanded(child: Text("${goal['score2']}"), flex: 1),
          ],
        ));
      }
    }

    return Center(
      child: Column(
        children: <Widget>[
          Container(
            child: Text("${m['team1']['name']}-${m['team2']['name']}"),
            padding: insets,
          ),
          Container(
            child: Text("Score: $s1 : $s2"),
            padding: insets,
          ),
          Container(
            child: Text(extensionStr),
            padding: insets,
          ),
          Container(
            child: Column(
              children: goals,
            ),
            padding: insets,
          ),
          MaterialButton(
            child: Text("Go back"),
            onPressed: () {
              print("Two");
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
