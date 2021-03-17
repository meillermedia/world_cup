import 'dart:convert';

import 'package:flutter/material.dart';

import 'details_page.dart';
import 'read_cached_data.dart';

void main() => runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: new FootballApp()));

const String wc_uri = "raw.githubusercontent.com";
const String wc_path = "/openfootball/world-cup.json/master/2018/worldcup.json";

class FootballApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var fbs = FootballAppState();

    return fbs;
  }
}

class FootballAppState extends State<FootballApp> {
  List<Widget> _gamesList = <Widget>[];

  void _getFootballResults() async {
    setState(() {
      _gamesList = <Widget>[
        Center(
          child: Text("Please wait"),
        ),
        Center(
          child: new Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator()),
        ),
        Center(
          child: Text("Loading results"),
        ),
      ];
    });
    var response = await readCachedData(name: 'football.json', uri: wc_uri, path: wc_path);
    setState(() {
      _gamesList = <Widget>[];
    });
    Map<String, dynamic> wc = json.decode(response);
    for (var r in wc['rounds']) {
      print(r['name']);
      var day = <String>[];
      var teams = <String>[];
      var scores = <String>[];
      for (var m in r['matches']) {
        day.add(m['group'] ?? ' ');
        teams.add("${m['team1']['name']}-${m['team2']['name']}");
        var s1et = m['score1et'] ?? 0;
        var s2et = m['score2et'] ?? 0;
        var score = m['score1'] == null || m['score2'] == null
            ? '? : ?'
            : "${m['score1'] + s1et} : ${m['score2'] + s2et}";
        scores.add(score);
      }
      try {
        _addResult(r['name'], day, teams, scores, r);
      } finally {
        //Nothing
      }
    }
  }

  void _addResult(String day, List<String> groups, List<String> teams,
      List<String> scores, Map<String, dynamic> details) {
    List<Widget> groupList = <Widget>[];
    for (String s in groups) {
      groupList.add(Text(s));
    }
    List<Widget> teamList = <Widget>[];
    for (String s in teams) {
      teamList.add(Text(s));
    }
    List<Widget> scoreList = <Widget>[];
    for (String s in scores) {
      scoreList.add(Text(s));
    }
    var rows = <Widget>[];
    for (int i = 0; i < teamList.length; i++) {
      Row r = Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: groupList[i],
            flex: 1,
          ),
          Expanded(
            child: teamList[i],
            flex: 2,
          ),
          Expanded(
            child: scoreList[i],
            flex: 1,
          ),
        ],
      );
      var ink = InkWell(
        child: Padding(
          child: r,
          padding: EdgeInsets.all(10.0),
        ),
        highlightColor: Colors.blue,
        splashColor: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        onTap: () {
          Navigator.of(this.context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return detailsPage(details, i);
          }));
        },
      );
      rows.add(ink);
    }
    var col = Column(
      children: rows,
    );

    SingleChildScrollView s = SingleChildScrollView(
      child: col,
    );

    Card c = Card(
        child: Column(
      children: <Widget>[
        Container(
          child: Text(day),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(color: Colors.lightBlue),
          alignment: FractionalOffset.center,
        ),
        Expanded(
          child: s,
        ),
      ],
    ));
    setState(() {
      _gamesList.add(c);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Worldcup 2018"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(children: <Widget>[
            MaterialButton(
              child: InkWell(child: Text("Reload")),
              highlightColor: Colors.orange,
              splashColor: Colors.orange,
              onPressed: _getFootballResults,
            ),
            Expanded(
              child: OrientationBuilder(
                  builder: (BuildContext context, Orientation orientation) {
                var size = MediaQuery.of(context).size;
                print(size.height);
                if (orientation == Orientation.landscape) {
                  return GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: size.height / 752.0 * 2.4,
                      children: _gamesList);
                } else {
                  return GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: size.height / 1232.0 * 4.5,
                      children: _gamesList);
                }
              }),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getFootballResults();
  }
}
