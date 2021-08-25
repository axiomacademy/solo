import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';

import '../models/learner.dart';
import '../theme.dart';

class ProgressLogPage extends StatefulWidget {
  ProgressLogPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProgressLogPage());
  }

  @override
  _ProgressLogPageState createState() => _ProgressLogPageState();
}

class _ProgressLogPageState extends State<ProgressLogPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Provider<ProgressLogHandler>(
        create: (_) => ProgressLogHandler(),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          theme: buildTheme(),
          routes: {
            '/': (context) => MissionSelectView(),
            '/level': (context) => ProgressLevelView(),
            '/text': (context) => ProgressTextView(endLogFlow: _finishLog)
          },
        ));
  }

  void _finishLog() {
    Navigator.of(context).pop();
  }
}

class ProgressLogHandler {
  String _missionId = '';
  int _level = 0;
  String _text = '';

  void setMissionId(String id) {
    _missionId = id;
  }

  void setLevel(int level) {
    _level = level;
  }

  void setText(String text) {
    _text = text;
  }

  Future<void> createLog() async {
    User? user = FirebaseAuth.instance.currentUser!;
    final logRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/logs')
        .withConverter<Log>(
          fromFirestore: (snapshot, _) => Log.fromJson(snapshot.data()!),
          toFirestore: (log, _) => log.toJson(),
        );

    await logRef.add(Log(
        type: 'progress',
        mission: _missionId,
        progressLevel: _level,
        progressLog: _text));
  }
}

class ProgressTextView extends StatefulWidget {
  ProgressTextView({Key? key, required this.endLogFlow}) : super(key: key);

  final VoidCallback endLogFlow;

  @override
  _ProgressTextViewState createState() => _ProgressTextViewState();
}

class _ProgressTextViewState extends State<ProgressTextView> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Theme.of(context).primaryColor))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Theme.of(context).primaryColor))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Theme.of(context).primaryColor))),
                      ]),
                      Container(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Text("Show off your progress 🚀",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                controller: _controller,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(height: 1.6),
                                cursorColor: Theme.of(context).primaryColor,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  hintMaxLines: 10,
                                  hintText:
                                      "You've come so far! Time to brag a little, tell us what you've done. Talk about how your learning strategies are working, and whether changes need to be made.\n\n* I learnt...\n* I think this should be done better by...",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          height: 1.5, color: Colors.grey[500]),
                                ),
                              ))),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                Provider.of<ProgressLogHandler>(context,
                                        listen: false)
                                    .setText(_controller.value.text);
                                await Provider.of<ProgressLogHandler>(context,
                                        listen: false)
                                    .createLog();
                                widget.endLogFlow();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("Submit Log".toUpperCase()),
                                Spacer(),
                              ])))
                    ]))));
  }
}

class ProgressLevelView extends StatefulWidget {
  ProgressLevelView({Key? key}) : super(key: key);

  @override
  _ProgressLevelViewState createState() => _ProgressLevelViewState();
}

class _ProgressLevelViewState extends State<ProgressLevelView> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Theme.of(context).primaryColor))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Theme.of(context).primaryColor))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Colors.grey[200]))),
                      ]),
                      Spacer(),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text("Rate your skill level",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 1;
                                  });
                                },
                                child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        color: (selected == 1)
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey[200]),
                                    child: Center(
                                        child: Text("1",
                                            style: (selected == 1)
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        color: Colors.white)
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headline6)))),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 2;
                                  });
                                },
                                child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        color: (selected == 2)
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey[200]),
                                    child: Center(
                                        child: Text("2",
                                            style: (selected == 2)
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        color: Colors.white)
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headline6)))),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 3;
                                  });
                                },
                                child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        color: (selected == 3)
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey[200]),
                                    child: Center(
                                        child: Text("3",
                                            style: (selected == 3)
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        color: Colors.white)
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headline6)))),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 4;
                                  });
                                },
                                child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        color: (selected == 4)
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey[200]),
                                    child: Center(
                                        child: Text("4",
                                            style: (selected == 4)
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        color: Colors.white)
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headline6)))),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 5;
                                  });
                                },
                                child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        color: (selected == 5)
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey[200]),
                                    child: Center(
                                        child: Text("5",
                                            style: (selected == 5)
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        color: Colors.white)
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headline6)))),
                          ]),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Provider.of<ProgressLogHandler>(context,
                                        listen: false)
                                    .setLevel(selected);
                                Navigator.of(context).pushNamed('/text');
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("Next".toUpperCase()),
                                Spacer(),
                              ])))
                    ]))));
  }
}

class MissionSelectView extends StatefulWidget {
  MissionSelectView({Key? key}) : super(key: key);

  @override
  _MissionSelectViewState createState() => _MissionSelectViewState();
}

class _MissionSelectViewState extends State<MissionSelectView> {
  late Stream<QuerySnapshot<Mission>> _missionStream;

  @override
  void initState() {
    // Setting up stream from firebase
    User user = FirebaseAuth.instance.currentUser!;
    _missionStream = FirebaseFirestore.instance
        .collection('learners/${user.email}/missions')
        .withConverter<Mission>(
          fromFirestore: (snapshot, _) => Mission.fromJson(snapshot.data()!),
          toFirestore: (mission, _) => mission.toJson(),
        )
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Theme.of(context).primaryColor))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Colors.grey[200]))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Colors.grey[200]))),
                      ]),
                      Spacer(),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text("Which mission are you logging?",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      StreamBuilder<QuerySnapshot>(
                          stream: _missionStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Mission mission = document.data()! as Mission;
                                  return GestureDetector(
                                      onTap: () {
                                        // Figure out how store ID
                                        Provider.of<ProgressLogHandler>(context,
                                                listen: false)
                                            .setMissionId(document.id);
                                        Navigator.of(context)
                                            .pushNamed('/level');
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          padding: EdgeInsets.all(30.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Row(children: <Widget>[
                                                  Text(mission.title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6),
                                                  Spacer(),
                                                  Text("54 logs".toUpperCase(),
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .overline
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                ]),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10.0),
                                                    child: Text(
                                                      mission.purpose,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ))
                                              ])));
                                }).toList());
                          }),
                    ]))));
  }
}
