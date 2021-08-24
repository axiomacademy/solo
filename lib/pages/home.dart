import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/learner.dart';
import 'progress_log.dart';
import 'challenge_log.dart';
import 'recall_log.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Stream<QuerySnapshot<Learner>> _learnerStream;

  List<Widget> _widgetOptions = <Widget>[
    ExplorePage(),
    LogPage(),
    JourneyPage()
  ];

  @override
  void initState() {
    // Setting up stream from firebase
    User user = FirebaseAuth.instance.currentUser!;
    _learnerStream = FirebaseFirestore.instance
        .collection('learners')
        .where('email', isEqualTo: user.email)
        .withConverter<Learner>(
          fromFirestore: (snapshot, _) => Learner.fromJson(snapshot.data()!),
          toFirestore: (learner, _) => learner.toJson(),
        )
        .snapshots();

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _learnerStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          Learner learner = snapshot.data!.docs.single.data() as Learner;

          return Material(
              child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80.0),
                child: SafeArea(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(children: <Widget>[
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEE7FA),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text("🪙  ${learner.coins}",
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEE7FA),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Text("⚡${learner.energy}",
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                          Spacer(),
                          CircleAvatar(backgroundColor: Colors.grey[300])
                        ])))),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.public),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.biotech),
                  label: 'Mission Log',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.face),
                  label: 'Journey',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: _onItemTapped,
            ),
          ));
        });
  }
}

class JourneyPage extends StatefulWidget {
  JourneyPage({Key? key}) : super(key: key);

  @override
  _JourneyPageState createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
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
            child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Text("Active Missions",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(fontSize: 24)),
                          ),
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
                                      Mission mission =
                                          document.data()! as Mission;
                                      return Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          padding: EdgeInsets.all(30.0),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(children: <Widget>[
                                                  Text(mission.title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .white)),
                                                  Spacer(),
                                                  Text("54 logs".toUpperCase(),
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .overline
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .white)),
                                                ]),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10.0),
                                                    child: Text(
                                                      mission.purpose,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ))
                                              ]));
                                    }).toList());
                              }),
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Text("Recent Activity",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(fontSize: 24)),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              padding: EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              child: Row(children: <Widget>[
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("React Basics",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Container(
                                          child: Text("🏗️ Build an app",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1))
                                    ]),
                                Spacer(),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEEE7FA),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Text("🤔 Recall",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)),
                              ])),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              padding: EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              child: Row(children: <Widget>[
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Progress on App",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Container(
                                          child: Text("🏗️ Build an app",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1))
                                    ]),
                                Spacer(),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEEE7FA),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Text("🔥 Progress",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)),
                              ])),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              padding: EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              child: Row(children: <Widget>[
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Draw a Boat",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Container(
                                          child: Text("🏗️ Build an app",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1))
                                    ]),
                                Spacer(),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEEE7FA),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Text("🥊 Challenge",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)),
                              ])),
                        ])))));
  }
}

class LogPage extends StatefulWidget {
  LogPage({Key? key}) : super(key: key);

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: SingleChildScrollView(
                child: Container(
      padding: EdgeInsets.all(30.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Container(
            height: 400,
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: Center(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text("Review your knowledge",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text("To boost your retention",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Colors.white)))
            ]))),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Text("Challenges",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: 24)),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 10.0),
            child: Row(children: <Widget>[
              Container(
                  width: 300,
                  height: 160,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("✨ Draw a boot",
                            style: Theme.of(context).textTheme.headline5),
                        Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text("Mission: Draw a figure",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: Colors.grey[500]))),
                        Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text(
                                "Follow the Udemy course and draw a boot to practice contour and cross contour lines",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText2))
                      ])),
            ])),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Text("Logging",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: 24)),
        ),
        Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(children: <Widget>[
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(RecallLogPage.route());
                      },
                      child: Container(
                          height: 50,
                          margin: EdgeInsets.all(5.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Center(
                              child: Text("🧠 Content",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1))))),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(ChallengeLogPage.route());
                    },
                    child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Center(
                            child: Text("🥊 Challenge",
                                style:
                                    Theme.of(context).textTheme.subtitle1)))),
              )
            ])),
        Row(children: <Widget>[
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(ProgressLogPage.route());
                  },
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.all(5.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Center(
                          child: Text("🔥 Progress",
                              style: Theme.of(context).textTheme.subtitle1))))),
          Expanded(
            child: GestureDetector(
                onTap: () {},
                child: Container(
                    height: 50,
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Center(
                        child: Text("🧠 Cards",
                            style: Theme.of(context).textTheme.subtitle1)))),
          )
        ])
      ]),
    ))));
  }
}

class ExplorePage extends StatefulWidget {
  ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Earth",
                          style: Theme.of(context).primaryTextTheme.headline2),
                      Text("The Solar System",
                          style: Theme.of(context).textTheme.headline5),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: LinearProgressIndicator(
                              minHeight: 10.0,
                              value: 0.5,
                              backgroundColor: Colors.purple[50],
                              color: Theme.of(context).primaryColor)),
                      Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Row(children: [
                            Text("Mining Progress".toUpperCase(),
                                style: Theme.of(context).textTheme.overline),
                            Spacer(),
                            Text("🪙  10",
                                style: Theme.of(context).textTheme.subtitle1)
                          ])),
                      Expanded(
                          child: Card(
                              elevation: 0,
                              color: Colors.grey[100],
                              margin: EdgeInsets.only(top: 20.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Center(
                                  child: Container(
                                width: 250,
                                child: Text(
                                    "Working on cool game elements to bring to you 🏗️",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(color: Colors.grey[600])),
                              )))),
                    ]))));
  }
}
